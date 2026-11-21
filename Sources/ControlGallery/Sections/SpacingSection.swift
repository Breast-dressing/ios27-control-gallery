import SwiftUI

struct SpacingSection: View {
    @EnvironmentObject private var store: GalleryStore

    private var spacingCode: String {
        [
            "VStack(spacing: \(Int(store.spacingValue(24)))) {",
            "    Text(\"间距\")",
            "}",
            ".padding(\(Int(store.spacingValue(16))))   // 基准 16pt × \(String(format: \"%.2f\", store.spacingScale))"
        ].joined(separator: "\n")
    }

    private var sizeCode: String {
        [
            "Button(\"主要操作\") { }",
            "    .buttonStyle(.borderedProminent)",
            "    \(store.controlSizeModifier)",
            "    \(store.buttonBorderShapeSample)",
            "    \(store.tintModifier)"
        ].joined(separator: "\n")
    }

    private var radiusCode: String {
        [
            store.cornerRadiusSample,
            "    .overlay { Text(\"圆角\").font(.caption) }",
            "    .frame(width: 84, height: 84)"
        ].joined(separator: "\n")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SectionHeader(
                    title: "间距与尺寸",
                    subtitle: "4pt 间距阶梯 · 控件尺寸 5 档 · 圆角（代码随滑块变化）"
                )

                GalleryCard {
                    HStack {
                        Text("间距比例").font(.headline)
                        Spacer()
                        ValuePill(text: String(format: "%.2fx", store.spacingScale))
                    }
                    Slider(value: $store.spacingScale, in: 0.6...1.6, step: 0.05)
                        .accessibilityLabel("间距比例")

                    Text("所有间距都按 4pt 基准乘以比例，下面每行的 pt 值与代码块里的 padding 同步变化。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                CodeBlock(api: "VStack(spacing:) · View.padding(_:)", code: spacingCode)

                Text("间距阶梯").font(.headline).padding(.horizontal, 4)

                GalleryCard {
                    ForEach(GalleryCatalog.spacing) { token in
                        HStack(spacing: 10) {
                            Text(token.id)
                                .font(.caption2)
                                .monospacedDigit()
                                .frame(width: 28, alignment: .trailing)
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(store.tintColor.opacity(0.85))
                                .frame(width: store.spacingValue(token.value), height: 14)
                            Spacer()
                            Text(".padding(\(Int(store.spacingValue(token.value))))")
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                        }
                    }
                }

                Text("按钮默认尺寸").font(.headline).padding(.horizontal, 4)

                GalleryCard {
                    HStack {
                        Text("Control Size").font(.headline)
                        Spacer()
                        ValuePill(text: store.controlSizeName)
                    }
                    Slider(
                        value: $store.controlSizeIndex,
                        in: 0...Double(GalleryCatalog.controlSizes.count - 1),
                        step: 1
                    )
                    .accessibilityLabel("控件尺寸")

                    HStack(spacing: 10) {
                        ForEach(GalleryCatalog.controlSizes.indices, id: \.self) { index in
                            let token = GalleryCatalog.controlSizes[index]
                            Button(token.id) {}
                                .buttonStyle(.bordered)
                                .controlSize(token.size)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Divider()

                    HStack(spacing: 12) {
                        Button("主要操作") {}.buttonStyle(.borderedProminent)
                        Button("次要操作") {}.buttonStyle(.bordered)
                        Button("文本按钮") {}.buttonStyle(.borderless)
                    }
                    .controlSize(store.controlSize)

                    Stepper("数量", value: .constant(1), in: 1...5)
                        .controlSize(store.controlSize)

                    Toggle("开关", isOn: .constant(true))
                        .controlSize(store.controlSize)

                    DatePicker("日期", selection: .constant(Date()), displayedComponents: .date)
                        .controlSize(store.controlSize)
                }

                CodeBlock(api: "ControlSize · View.controlSize(_:) · ButtonBorderShape", code: sizeCode)

                Text("圆角").font(.headline).padding(.horizontal, 4)

                GalleryCard {
                    HStack {
                        Text("Corner Radius").font(.headline)
                        Spacer()
                        ValuePill(text: String(format: "%.0f pt", store.cornerRadius))
                    }
                    Slider(value: $store.cornerRadius, in: 0...32, step: 2)
                        .accessibilityLabel("圆角")

                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: store.cornerRadius, style: .continuous)
                            .fill(store.tintColor.opacity(0.85))
                            .frame(width: 84, height: 84)
                            .overlay {
                                Text("圆角").font(.caption).foregroundStyle(.white)
                            }
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Button border shape")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            HStack(spacing: 8) {
                                Button("按钮") {}
                                    .buttonStyle(.borderedProminent)
                                    .buttonBorderShape(.roundedRectangle(radius: store.cornerRadius))
                                Button("胶囊") {}
                                    .buttonStyle(.bordered)
                                    .buttonBorderShape(.capsule)
                            }
                            .controlSize(.small)
                        }
                    }
                }

                CodeBlock(api: "RoundedRectangle(cornerRadius:style:) · ButtonBorderShape", code: radiusCode)
            }
            .padding(16)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("间距")
    }
}
