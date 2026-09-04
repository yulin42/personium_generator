import Foundation

/// Reads local build configuration. The OpenAI key is injected into the
/// generated Info.plist from `Config/Secrets.xcconfig`, which is not committed.
/// When that file is absent the key resolves to an empty string and generation
/// is disabled rather than the build failing.
nonisolated enum AppConfiguration {
    static var openAIAPIKey: String? {
        guard let raw = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String else {
            return nil
        }

        let key = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !key.isEmpty, key != "sk-replace-me" else { return nil }

        return key
    }
}
