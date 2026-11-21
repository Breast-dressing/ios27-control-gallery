import SwiftUI

enum ColorSchemeChoice: String, CaseIterable, Identifiable {
    case system, light, dark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: return "跟随系统"
        case .light: return "浅色"
        case .dark: return "深色"
        }
    }

    var scheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

enum ListStyleChoice: String, CaseIterable, Identifiable {
    case insetGrouped, grouped, plain, sidebar

    var id: String { rawValue }

    var title: String {
        switch self {
        case .insetGrouped: return "insetGrouped"
        case .grouped: return "grouped"
        case .plain: return "plain"
        case .sidebar: return "sidebar"
        }
    }
}

/// 全局可调的系统外观与尺寸参数，供各页面共用。
final class GalleryStore: ObservableObject {
    @Published var colorSchemeChoice: ColorSchemeChoice = .system
    @Published var dynamicTypeIndex: Double = 3
    @Published var controlSizeIndex: Double = 2
    @Published var spacingScale: Double = 1.0
    @Published var cornerRadius: Double = 12
    @Published var tintIndex: Int = 0
    @Published var boldText: Bool = false
    @Published var increaseContrast: Bool = false
    @Published var fontDesignIndex: Int = 0
    @Published var fontWeightIndex: Double = 3
    @Published var listStyleChoice: ListStyleChoice = .insetGrouped

    var colorScheme: ColorScheme? { colorSchemeChoice.scheme }

    var dynamicTypeToken: GalleryCatalog.DynamicTypeToken {
        let index = min(max(Int(dynamicTypeIndex.rounded()), 0), GalleryCatalog.dynamicTypes.count - 1)
        return GalleryCatalog.dynamicTypes[index]
    }

    var dynamicTypeSize: DynamicTypeSize { dynamicTypeToken.size }
    var dynamicTypeName: String { dynamicTypeToken.id }

    var controlSize: ControlSize {
        let index = min(max(Int(controlSizeIndex.rounded()), 0), GalleryCatalog.controlSizes.count - 1)
        return GalleryCatalog.controlSizes[index].size
    }

    var controlSizeName: String {
        let index = min(max(Int(controlSizeIndex.rounded()), 0), GalleryCatalog.controlSizes.count - 1)
        return GalleryCatalog.controlSizes[index].id
    }

    var tintColor: Color { GalleryCatalog.tintColors[clampedTintIndex].color }

    var clampedTintIndex: Int {
        min(max(tintIndex, 0), GalleryCatalog.tintColors.count - 1)
    }

    var tintName: String { GalleryCatalog.tintColors[clampedTintIndex].id }

    var fontDesign: Font.Design {
        let index = min(max(fontDesignIndex, 0), GalleryCatalog.fontDesigns.count - 1)
        return GalleryCatalog.fontDesigns[index].design
    }

    var fontWeight: Font.Weight {
        let index = min(max(Int(fontWeightIndex.rounded()), 0), GalleryCatalog.fontWeights.count - 1)
        return GalleryCatalog.fontWeights[index].weight
    }

    var fontWeightName: String {
        let index = min(max(Int(fontWeightIndex.rounded()), 0), GalleryCatalog.fontWeights.count - 1)
        return GalleryCatalog.fontWeights[index].id
    }

    var scale: CGFloat { CGFloat(spacingScale) }

    /// 以 16pt 为基准的正文间距，乘以全局比例
    var bodySpacing: CGFloat { 16 * scale }

    func spacingValue(_ base: CGFloat) -> CGFloat { base * scale }

    // MARK: - 实时示例代码（参数一变，代码跟着变）

    var fontDesignAPIName: String {
        let names = [".default", ".serif", ".rounded", ".monospaced"]
        let index = min(max(fontDesignIndex, 0), names.count - 1)
        return names[index]
    }

    var dynamicTypeModifier: String { ".dynamicTypeSize(.\(dynamicTypeName))" }

    var fontDesignModifier: String { ".fontDesign(\(fontDesignAPIName))" }

    var fontWeightModifier: String { ".fontWeight(.\(fontWeightName))" }

    var controlSizeModifier: String { ".controlSize(.\(controlSizeName))" }

    var tintModifier: String { ".tint(.\(tintName))" }

    var colorSchemeModifier: String {
        switch colorSchemeChoice {
        case .system: return "// 跟随系统：不设置 preferredColorScheme"
        case .light: return ".preferredColorScheme(.light)"
        case .dark: return ".preferredColorScheme(.dark)"
        }
    }

    var cornerRadiusSample: String {
        "RoundedRectangle(cornerRadius: \(Int(cornerRadius)), style: .continuous)"
    }

    var buttonBorderShapeSample: String {
        ".buttonBorderShape(.roundedRectangle(radius: \(Int(min(cornerRadius, 22)))))"
    }

    var paddingSample: String { ".padding(\(Int(spacingValue(16))))" }

    var listStyleSample: String { ".listStyle(.\(listStyleChoice.rawValue))" }
}
