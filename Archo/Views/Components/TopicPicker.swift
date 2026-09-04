import SwiftUI

struct TopicPicker: View {
    @Binding var selection: Topic

    private let columns = [GridItem(.adaptive(minimum: 120), spacing: 10)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(Topic.allCases) { topic in
                let isSelected = topic == selection

                Button {
                    withAnimation(.snappy(duration: 0.2)) {
                        selection = topic
                    }
                } label: {
                    Text(topic.rawValue)
                        .font(.callout)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            isSelected ? AnyShapeStyle(Color.accentColor.opacity(0.14))
                                       : AnyShapeStyle(.fill.tertiary),
                            in: .rect(cornerRadius: 14, style: .continuous)
                        )
                        .foregroundStyle(isSelected ? Color.accentColor : .primary)
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
            }
        }
    }
}

#Preview {
    @Previewable @State var topic: Topic = .reflection

    return TopicPicker(selection: $topic)
        .padding()
}
