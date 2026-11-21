import SwiftUI

struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            if let subtitle {
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct GalleryCard<Content: View>: View {
    @EnvironmentObject private var store: GalleryStore
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color(uiColor: .secondarySystemGroupedBackground),
            in: RoundedRectangle(cornerRadius: store.cornerRadius, style: .continuous)
        )
    }
}

struct ControlCaption: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption2)
            .foregroundStyle(.secondary)
    }
}

struct ValuePill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption2)
            .monospacedDigit()
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.secondary.opacity(0.12), in: Capsule())
    }
}

struct TokenRow<Content: View>: View {
    let name: String
    let value: String
    private let content: Content

    init(_ name: String, value: String, @ViewBuilder content: () -> Content) {
        self.name = name
        self.value = value
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(name)
                    .font(.subheadline)
                Spacer()
                Text(value)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            content
        }
    }
}
