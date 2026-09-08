import Foundation

enum GenerationError: Error, LocalizedError, Equatable {
    case missingAPIKey
    case offline
    case failed

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            "Add an OpenRouter API key in Config/Secrets.xcconfig to generate posts."
        case .offline:
            "You appear to be offline. Check your connection and try again."
        case .failed:
            "Couldn't generate posts right now. Please try again."
        }
    }
}

/// Turns a topic into a list of short posts via OpenRouter. The caller decides
/// what to do with the strings; this type knows nothing about SwiftData or SwiftUI.
nonisolated struct AIService {
    private let apiKey: String?
    private let model: String
    private let session: URLSession

    private static let endpoint = URL(string: "https://openrouter.ai/api/v1/chat/completions")!
    private static let appURL = "https://archo.app"
    private static let appTitle = "Archo"

    init(
        apiKey: String? = AppConfiguration.openRouterAPIKey,
        model: String = AppConfiguration.openRouterModel,
        session: URLSession = .shared
    ) {
        self.apiKey = apiKey
        self.model = model
        self.session = session
    }

    func generatePosts(category: String, count: Int) async throws -> [String] {
        guard let apiKey else { throw GenerationError.missingAPIKey }

        var request = URLRequest(url: Self.endpoint)
        request.httpMethod = "POST"
        request.timeoutInterval = 90
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue(Self.appURL, forHTTPHeaderField: "HTTP-Referer")
        request.setValue(Self.appTitle, forHTTPHeaderField: "X-OpenRouter-Title")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody(category: category, count: count))

        guard request.httpBody != nil else { throw GenerationError.failed }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet, .networkConnectionLost, .cannotFindHost, .dataNotAllowed:
                throw GenerationError.offline
            default:
                throw GenerationError.failed
            }
        } catch {
            throw GenerationError.failed
        }

        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw GenerationError.failed
        }

        let posts = Self.decodePosts(from: data)
        guard !posts.isEmpty else { throw GenerationError.failed }

        return Array(posts.prefix(count))
    }
}

// MARK: - Request

private nonisolated extension AIService {
    func requestBody(category: String, count: Int) -> [String: Any] {
        [
            "model": model,
            "temperature": 1.0,
            "messages": [
                ["role": "system", "content": Self.systemPrompt],
                [
                    "role": "user",
                    "content": "Write \(count) posts on the theme of \(category). Each one must express a different idea.",
                ],
            ],
            "response_format": [
                "type": "json_schema",
                "json_schema": [
                    "name": "archo_posts",
                    "strict": true,
                    "schema": [
                        "type": "object",
                        "properties": [
                            "posts": [
                                "type": "array",
                                "items": ["type": "string"],
                            ]
                        ],
                        "required": ["posts"],
                        "additionalProperties": false,
                    ],
                ],
            ],
            // Prefer providers that actually honor `response_format`.
            "provider": [
                "require_parameters": true,
            ],
        ]
    }

    static let systemPrompt = """
    You write short, thoughtful posts for a calm reading app.

    Rules for every post:
    - One to three sentences.
    - Concise, specific, and human-sounding.
    - Each post stands completely on its own and expresses a distinct idea.
    - No hashtags, emoji, numbering, quotation marks, titles, or markdown.
    - Do not repeat phrasing or ideas across posts.
    - Do not reference other posts, users, comments, or the app itself.

    Return only the JSON object described by the schema.
    """
}

// MARK: - Response

nonisolated extension AIService {
    struct ChatCompletion: Decodable {
        struct Choice: Decodable {
            struct Message: Decodable {
                let content: String?
            }

            let message: Message
        }

        let choices: [Choice]
    }

    struct PostsPayload: Decodable {
        let posts: [String]
    }

    /// Model output is structured, but still gets cleaned up: strays like
    /// leading list markers or wrapping quotes would otherwise reach the feed.
    static func decodePosts(from data: Data) -> [String] {
        guard
            let completion = try? JSONDecoder().decode(ChatCompletion.self, from: data),
            let content = completion.choices.first?.message.content,
            let payload = try? JSONDecoder().decode(PostsPayload.self, from: Data(content.utf8))
        else {
            return []
        }

        var seen = Set<String>()
        return payload.posts.compactMap { raw -> String? in
            let text = clean(raw)
            guard text.count > 1, seen.insert(text.lowercased()).inserted else { return nil }
            return text
        }
    }

    static func clean(_ raw: String) -> String {
        var text = raw.trimmingCharacters(in: .whitespacesAndNewlines)

        while let first = text.first, first == "-" || first == "•" || first == "*" {
            text = String(text.dropFirst()).trimmingCharacters(in: .whitespaces)
        }

        text = text.replacingOccurrences(
            of: "^\\d+[.)]\\s*",
            with: "",
            options: .regularExpression
        )

        if text.count > 1, let first = text.first, let last = text.last,
           (first == "\"" && last == "\"") || (first == "\u{201C}" && last == "\u{201D}") {
            text = String(text.dropFirst().dropLast())
        }

        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
