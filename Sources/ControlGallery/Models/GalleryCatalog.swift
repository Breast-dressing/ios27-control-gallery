import SwiftUI

/// 纯数据的系统设计令牌目录：字号、颜色、间距、控件尺寸。
/// 单独放在这里是为了能被单元测试直接断言（不依赖 UI）。
enum GalleryCatalog {

    // MARK: - 系统文本样式（Dynamic Type 全量）

    struct TextStyleToken: Identifiable {
        let id: String
        let font: Font
        let sample: String
    }

    /// iOS 可用的系统文本样式（iOS 上的 extraLargeTitle 系列不可用，故不列出）
    static let textStyles: [TextStyleToken] = [
        .init(id: "largeTitle", font: .largeTitle, sample: "大标题 Large Title"),
        .init(id: "title", font: .title, sample: "标题 Title"),
        .init(id: "title2", font: .title2, sample: "二级标题 Title 2"),
        .init(id: "title3", font: .title3, sample: "三级标题 Title 3"),
        .init(id: "headline", font: .headline, sample: "标题行 Headline"),
        .init(id: "subheadline", font: .subheadline, sample: "副标题 Subheadline"),
        .init(id: "body", font: .body, sample: "正文 Body：iOS 27 的系统字号会随 Dynamic Type 缩放。"),
        .init(id: "callout", font: .callout, sample: "标注 Callout"),
        .init(id: "footnote", font: .footnote, sample: "脚注 Footnote"),
        .init(id: "caption", font: .caption, sample: "说明 Caption"),
        .init(id: "caption2", font: .caption2, sample: "最小说明 Caption 2")
    ]

    // MARK: - Dynamic Type 尺寸级别

    struct DynamicTypeToken: Identifiable {
        let id: String
        let size: DynamicTypeSize
    }

    static let dynamicTypes: [DynamicTypeToken] = [
        .init(id: "xSmall", size: .xSmall),
        .init(id: "small", size: .small),
        .init(id: "medium", size: .medium),
        .init(id: "large", size: .large),
        .init(id: "xLarge", size: .xLarge),
        .init(id: "xxLarge", size: .xxLarge),
        .init(id: "xxxLarge", size: .xxxLarge),
        .init(id: "accessibility1", size: .accessibility1),
        .init(id: "accessibility2", size: .accessibility2),
        .init(id: "accessibility3", size: .accessibility3),
        .init(id: "accessibility4", size: .accessibility4),
        .init(id: "accessibility5", size: .accessibility5)
    ]

    // MARK: - 字体设计 / 字重

    struct FontDesignToken: Identifiable {
        let id: String
        let design: Font.Design
    }

    static let fontDesigns: [FontDesignToken] = [
        .init(id: "默认", design: .default),
        .init(id: "衬线", design: .serif),
        .init(id: "圆体", design: .rounded),
        .init(id: "等宽", design: .monospaced)
    ]

    struct FontWeightToken: Identifiable {
        let id: String
        let weight: Font.Weight
    }

    static let fontWeights: [FontWeightToken] = [
        .init(id: "ultraLight", weight: .ultraLight),
        .init(id: "thin", weight: .thin),
        .init(id: "light", weight: .light),
        .init(id: "regular", weight: .regular),
        .init(id: "medium", weight: .medium),
        .init(id: "semibold", weight: .semibold),
        .init(id: "bold", weight: .bold),
        .init(id: "heavy", weight: .heavy),
        .init(id: "black", weight: .black)
    ]

    // MARK: - 系统配色

    struct ColorToken: Identifiable {
        let id: String
        let color: Color
        let isSemantic: Bool
    }

    /// 系统强调色（适配浅色/深色与提高对比度）
    static let systemColors: [ColorToken] = [
        .init(id: "blue", color: .blue, isSemantic: false),
        .init(id: "green", color: .green, isSemantic: false),
        .init(id: "indigo", color: .indigo, isSemantic: false),
        .init(id: "orange", color: .orange, isSemantic: false),
        .init(id: "pink", color: .pink, isSemantic: false),
        .init(id: "purple", color: .purple, isSemantic: false),
        .init(id: "red", color: .red, isSemantic: false),
        .init(id: "teal", color: .teal, isSemantic: false),
        .init(id: "yellow", color: .yellow, isSemantic: false),
        .init(id: "mint", color: .mint, isSemantic: false),
        .init(id: "cyan", color: .cyan, isSemantic: false),
        .init(id: "brown", color: .brown, isSemantic: false),
        .init(id: "gray", color: .gray, isSemantic: false)
    ]

    /// 语义前景色：随外观自动变化
    static let semanticForegroundColors: [ColorToken] = [
        .init(id: "label", color: Color(uiColor: .label), isSemantic: true),
        .init(id: "secondaryLabel", color: Color(uiColor: .secondaryLabel), isSemantic: true),
        .init(id: "tertiaryLabel", color: Color(uiColor: .tertiaryLabel), isSemantic: true),
        .init(id: "quaternaryLabel", color: Color(uiColor: .quaternaryLabel), isSemantic: true),
        .init(id: "placeholderText", color: Color(uiColor: .placeholderText), isSemantic: true),
        .init(id: "separator", color: Color(uiColor: .separator), isSemantic: true),
        .init(id: "link", color: Color(uiColor: .link), isSemantic: true)
    ]

    /// 语义背景色：图层化背景（base / elevated）
    static let semanticBackgroundColors: [ColorToken] = [
        .init(id: "systemBackground", color: Color(uiColor: .systemBackground), isSemantic: true),
        .init(id: "secondarySystemBackground", color: Color(uiColor: .secondarySystemBackground), isSemantic: true),
        .init(id: "tertiarySystemBackground", color: Color(uiColor: .tertiarySystemBackground), isSemantic: true),
        .init(id: "systemGroupedBackground", color: Color(uiColor: .systemGroupedBackground), isSemantic: true),
        .init(id: "secondarySystemGroupedBackground", color: Color(uiColor: .secondarySystemGroupedBackground), isSemantic: true),
        .init(id: "systemFill", color: Color(uiColor: .systemFill), isSemantic: true),
        .init(id: "secondarySystemFill", color: Color(uiColor: .secondarySystemFill), isSemantic: true),
        .init(id: "tertiarySystemFill", color: Color(uiColor: .tertiarySystemFill), isSemantic: true),
        .init(id: "quaternarySystemFill", color: Color(uiColor: .quaternarySystemFill), isSemantic: true)
    ]

    static let tintColors: [ColorToken] = Array(systemColors.prefix(10))

    // MARK: - 间距与尺寸

    struct SpacingToken: Identifiable {
        let id: String
        let value: CGFloat
    }

    /// 4pt 基准的间距阶梯
    static let spacing: [SpacingToken] = [
        .init(id: "4", value: 4),
        .init(id: "8", value: 8),
        .init(id: "12", value: 12),
        .init(id: "16", value: 16),
        .init(id: "20", value: 20),
        .init(id: "24", value: 24),
        .init(id: "32", value: 32),
        .init(id: "40", value: 40),
        .init(id: "48", value: 48),
        .init(id: "64", value: 64)
    ]

    static let cornerRadii: [CGFloat] = [0, 4, 8, 12, 16, 20, 24, 32]

    struct ControlSizeToken: Identifiable {
        let id: String
        let size: ControlSize
    }

    /// 按钮/控件默认尺寸阶梯（mini → extraLarge）
    static let controlSizes: [ControlSizeToken] = [
        .init(id: "mini", size: .mini),
        .init(id: "small", size: .small),
        .init(id: "regular", size: .regular),
        .init(id: "large", size: .large),
        .init(id: "extraLarge", size: .extraLarge)
    ]
}
