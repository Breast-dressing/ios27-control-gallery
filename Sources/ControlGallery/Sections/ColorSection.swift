import SwiftUI

struct ColorSection: View {
    @EnvironmentObject private var store: GalleryStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SectionHeader(
                    title: "配色",
                    subtitle: "系统强调色 13 个 · 语义前景/背景色 · 强调色可切换"
                )

                GalleryCard {
                    Text("外观")
                        .font(.headline)
                    Picker("外观", selection: $store.colorSchemeChoice) {
                        ForEach(ColorSchemeChoice.allCases) { choice in
                            Text(choice.title).tag(choice)
                        }
                    }
                    .pickerStyle(.segmented)

                    Divider()

                    HStack {
                        Text("系统强调色（tint）")
                            .font(.headline)
                        Spacer()
                        HStack(spacing: 6) {
                            Circle()
                                .fill(store.tintColor)
                                .frame(width: 16, height: 16)
                            Text(store.tintName)
                                .font(.caption)
                                .foregroundStyle(.secondary)
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
                                    .overlay {
                                        Circle()
                                            .strokeBorder(Color.primary.opacity(0.18), lineWidth: 0.5)
                                    }
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

                Text("系统强调色")
                    .font(.headline)
                    .padding(.horizontal, 4)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 104), spacing: 12)], spacing: 12) {
                    ForEach(GalleryCatalog.systemColors) { token in
                        VStack(alignment: .leading, spacing: 6) {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(token.color)
                                .frame(height: 52)
                            Text(token.id)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Text("语义前景色")
                    .font(.headline)
                    .padding(.horizontal, 4)

                GalleryCard {
                    ForEach(GalleryCatalog.semanticForegroundColors) { token in
                        HStack(spacing: 12) {
                            Text("Aa 示例")
                                .font(.body)
                                .foregroundStyle(token.color)
                            Spacer()
                            Text(token.id)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Text("语义背景色")
                    .font(.headline)
                    .padding(.horizontal, 4)

                GalleryCard {
                    ForEach(GalleryCatalog.semanticBackgroundColors) { token in
                        HStack {
                            Text(token.id)
                                .font(.caption)
                            Spacer()
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(token.color)
                                .frame(width: 56, height: 26)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .strokeBorder(Color.secondary.opacity(0.3), lineWidth: 0.5)
                                }
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("配色")
    }
}
