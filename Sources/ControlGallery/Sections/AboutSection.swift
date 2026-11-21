import SwiftUI

struct AboutSection: View {
    @EnvironmentObject private var store: GalleryStore

    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }

    var body: some View {
        List {
            Section("工具链") {
                LabeledContent("Xcode", value: "27.2")
                LabeledContent("iOS SDK", value: "27.2")
                LabeledContent("Swift", value: "6.4 编译器 / Swift 5 语言模式")
                LabeledContent("工程", value: "XcodeGen 2.46.0 + SwiftUI")
                LabeledContent("App 版本", value: appVersion)
            }

            Section("设计令牌") {
                LabeledContent("文本样式", value: "\(GalleryCatalog.textStyles.count) 级")
                LabeledContent("Dynamic Type", value: "\(GalleryCatalog.dynamicTypes.count) 档")
                LabeledContent("系统强调色", value: "\(GalleryCatalog.systemColors.count) 个")
                LabeledContent("语义前景色", value: "\(GalleryCatalog.semanticForegroundColors.count) 个")
                LabeledContent("语义背景色", value: "\(GalleryCatalog.semanticBackgroundColors.count) 个")
                LabeledContent("间距阶梯", value: "\(GalleryCatalog.spacing.count) 档（4–64pt）")
                LabeledContent("控件尺寸", value: "\(GalleryCatalog.controlSizes.count) 档")
            }

            Section("当前全局状态") {
                LabeledContent("外观", value: store.colorSchemeChoice.title)
                LabeledContent("Dynamic Type", value: store.dynamicTypeName)
                LabeledContent("Control Size", value: store.controlSizeName)
                LabeledContent("强调色", value: store.tintName)
                LabeledContent("字重", value: store.fontWeightName)
                LabeledContent("间距比例", value: String(format: "%.2fx", store.spacingScale))
                LabeledContent("圆角", value: "\(Int(store.cornerRadius)) pt")
                LabeledContent("列表样式", value: store.listStyleChoice.title)
            }

            Section {
                Text("本 App 用 SwiftUI 展示 iOS 系统控件、文本样式、间距与配色。多形态控件（Dynamic Type、控件尺寸、列表样式、边框形状）通过滑块或 Picker 即时切换。构建由 GitHub Actions 的 xcode-27 镜像完成，产物为无签名 IPA。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("关于")
    }
}
