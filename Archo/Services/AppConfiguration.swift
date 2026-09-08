import Foundation

/// Reads local build configuration. Values are injected into the generated
/// Info.plist from `Config/Archo.xcconfig` and the optional, git-ignored
/// `Config/Secrets.xcconfig`. When the key file is absent, generation is
/// disabled rather than the build failing.
nonisolated enum AppConfiguration {
    private static let defaultModel = "deepseek/deepseek-v4-flash-0731"

    static var openRouterAPIKey: String? {
        guard let raw = Bundle.main.object(forInfoDictionaryKey: "OPENROUTER_API_KEY") as? String else {
            return nil
        }

        let key = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !key.isEmpty, key != "sk-or-replace-me" else { return nil }

        return key
    }

    /// OpenRouter model slug. Falls back to a structured-output-capable default
    /// when the build setting is missing or blank.
    static var openRouterModel: String {
        let raw = (Bundle.main.object(forInfoDictionaryKey: "OPENROUTER_MODEL") as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return raw.isEmpty ? defaultModel : raw
    }
}
