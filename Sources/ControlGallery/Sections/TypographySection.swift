import SwiftUI

struct TypographySection: View {
    @EnvironmentObject private var store: GalleryStore

    private var sampleCode: String {
        [
            "Text(\"iOS 27 设计系统\")",
            "    .font(.largeTitle)",
            "    \(store.dynamicTypeModifier)",
            "    \(store.fontDesignModifier)",
            "    \(store.fontWeightModifier)"
        ].joined(separator: "\n")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SectionHeader(
                    title: "排版",
                    subtitle: "11 级系统字号 · 12 档 Dynamic Type · 字体设计与字重（代码实时跟随滑块）"
                )

                GalleryCard {
                    HStack {
                        Text("Dynamic Type")
                            .font(.headline)
                        Spacer()
                        ValuePill(text: store.dynamicTypeName)
                    }

                    Slider(
                        value: $store.dynamicTypeIndex,
                        in: 0...Double(GalleryCatalog.dynamicTypes.count - 1),
                        step: 1
                    )
                    .accessibilityLabel("Dynamic Type 尺寸级别")

                    HStack {
                        ControlCaption(text: "xSmall")
                        Spacer()
                        ControlCaption(text: "accessibility5")
                    }

                    Divider()

                    Text("字体设计")
                        .font(.headline)
                    Picker("字体设计", selection: $store.fontDesignIndex) {
                        ForEach(GalleryCatalog.fontDesigns.indices, id: \.self) { index in
                            Text(GalleryCatalog.fontDesigns[index].id)
                                .tag(index)
                        }
                    }
                    .pickerStyle(.segmented)

                    Divider()

                    HStack {
                        Text("字重")
                            .font(.headline)
                        Spacer()
                        ValuePill(text: store.fontWeightName)
                    }
                    Slider(
                        value: $store.fontWeightIndex,
                        in: 0...Double(GalleryCatalog.fontWeights.count - 1),
                        step: 1
                    )
                    .accessibilityLabel("字重")

                    Text("中文与西文都会跟随字重变化")
                        .font(.system(size: 17, weight: store.fontWeight, design: store.fontDesign))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                CodeBlock(api: "Text · Font · DynamicTypeSize · Font.Design · Font.Weight", code: sampleCode)

                Text("系统文本样式")
                    .font(.headline)
                    .padding(.horizontal, 4)

                ForEach(GalleryCatalog.textStyles) { token in
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text("Font.\(token.id)")
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(".font(.\(token.id))")
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundStyle(.tertiary)
                        }
                        Text(token.sample)
                            .font(token.font)
                            .fontWeight(store.fontWeight)
                            .fontDesign(store.fontDesign)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 4)
                }

                DisclosureGroup("关于 Dynamic Type") {
                    Text("系统字号全部基于文本样式（Font.TextStyle），随 Dynamic Type 设置缩放。页面顶部的滑块直接改变整个 App 的 Dynamic Type 级别，可以在 xSmall 到 accessibility5 之间切换；上面的代码块里 .dynamicTypeSize(...) 会同步变化，可直接复制到其他项目。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 4)
            }
            .padding(16)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("排版")
    }
}
