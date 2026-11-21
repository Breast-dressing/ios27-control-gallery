import SwiftUI

struct ColorSection: View {
    @EnvironmentObject private var store: GalleryStore

    private var tintCode: String {
        [store.colorSchemeModifier, store.tintModifier].joined(separator: "\n")
    }

    private var semanticCode: String {
        "Text(\"正文\")\n    .foregroundStyle(Color(uiColor: .label))\nRectangle().fill(Color(uiColor: .systemBackground))"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SectionHeader(
                    title: "配色",
                    subtitle: "13 个系统强调色 · 语义前景/背景色 · 外观与 tint 代码实时变化"
                )

                GalleryCard {
                    Text("外观").font(.headline)
                    Picker("外观", selection: $store.colorSchemeChoice) {
                        ForEach(ColorSchemeChoice.allCases) { choice in
                            Text(choice.title).tag(choice)
                        }
                    }
                    .pickerStyle(.segmented)

                    Divider()

                    HStack {
                        Text("系统强调色（tint）").font(.headline)
                        Spacer()
                        HStack(spacing: 6) {
                            Circle().fill(store.tintColor).frame(width: 16, height: 16)
                            Text(store.tintName).font(.caption).foregroundStyle(.secondary)
                        }
                    }

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 40), spacing: 10)], spacing: 10) {
                        ForEach(GalleryCatalog.tintColors.indices, id: \.self) { index in
                            let token = GalleryCatalog.tintColors[index]
                            Button {
                                store.tintIndex = index
                            } label: {
                                Circle()
                                    .fill(token.color)
                                    .frame(width: 30, height: 30)
                                    .overlay { Circle().strokeBorder(Color.primary.opacity(0.18), lineWidth: 0.5) }
                                    .overlay {
                                        if index == store.clampedTintIndex {
                                            Image(systemName: "checkmark")
                                                .font(.caption2.bold())
                                                .foregroundStyle(.white)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(token.id)
                        }
                    }
                }

                CodeBlock(api: "ColorScheme · Color · View.tint(_:)", code: tintCode)

                Text("系统强调色").font(.headline).padding(.horizontal, 4)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 104), spacing: 12)], spacing: 12) {
                    ForEach(GalleryCatalog.systemColors) { token in
                        VStack(alignment: .leading, spacing: 6) {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(token.color)
                                .frame(height: 52)
                            Text(token.id).font(.caption).foregroundStyle(.secondary)
                            Text("Color.\(token.id)")
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundStyle(.tertiary)
                        }
                    }
                }

                Text("语义前景色").font(.headline).padding(.horizontal, 4)

                GalleryCard {
                    ForEach(GalleryCatalog.semanticForegroundColors) { token in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Color(uiColor: .\(token.id))")
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundStyle(.tertiary)
                            Text("Aa 示例").font(.body).foregroundStyle(token.color)
                        }
                    }
                }

                Text("语义背景色").font(.headline).padding(.horizontal, 4)

                GalleryCard {
                    ForEach(GalleryCatalog.semanticBackgroundColors) { token in
                        HStack {
                            Text(token.id).font(.caption)
                            Spacer()
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(token.color)
                                .frame(width: 40, height: 22)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .strokeBorder(Color.secondary.opacity(0.3), lineWidth: 0.5)
                                }
                        }
                    }
                }

                CodeBlock(api: "Color(uiColor:) · UIColor 语义色", code: semanticCode)
            }
            .padding(16)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("配色")
    }
}
