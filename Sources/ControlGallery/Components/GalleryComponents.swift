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

/// 贴在控件旁边的 API 名称（等宽，便于和代码里的符号对上）
struct APICaption: View {
    let api: String
    var note: String? = nil

    var body: some View {
        HStack(spacing: 6) {
            Text(api)
                .font(.system(.caption2, design: .monospaced))
                .foregroundStyle(.secondary)
            if let note {
                Text(note)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            Spacer(minLength: 0)
        }
    }
}

/// 可复制的 SwiftUI 示例代码块；code 由当前参数实时拼出来
struct CodeBlock: View {
    let api: String
    let code: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: "chevron.left.forwardslash.chevron.right")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(api)
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundStyle(.secondary)
                Spacer(minLength: 0)
            }

            Text(code)
                .font(.system(.caption, design: .monospaced))
                .textSelection(.enabled)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(
                    Color(uiColor: .tertiarySystemFill),
                    in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                )
        }
    }
}
