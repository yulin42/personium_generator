import SwiftData
import SwiftUI

struct RootTabView: View {
    enum AppTab: Hashable {
        case feed, generate, favorites
    }

    @State private var selection: AppTab = .feed

    var body: some View {
        TabView(selection: $selection) {
            Tab("Feed", systemImage: "list.bullet", value: AppTab.feed) {
                NavigationStack {
                    FeedView(onGenerate: { selection = .generate })
                }
            }

            Tab("Generate", systemImage: "sparkles", value: AppTab.generate) {
                NavigationStack {
                    GenerateView(onGenerated: { selection = .feed })
                }
            }

            Tab("Favorites", systemImage: "heart", value: AppTab.favorites) {
                NavigationStack {
                    FavoritesView()
                }
            }
        }
    }
}

#Preview {
    RootTabView()
        .modelContainer(PreviewData.container())
}
