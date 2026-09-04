import SwiftUI

struct PostCountPicker: View {
    @Binding var selection: PostCount

    var body: some View {
        Picker("Number of posts", selection: $selection) {
            ForEach(PostCount.allCases) { count in
                Text(count.label).tag(count)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    @Previewable @State var count: PostCount = .twenty

    return PostCountPicker(selection: $count)
        .padding()
}
