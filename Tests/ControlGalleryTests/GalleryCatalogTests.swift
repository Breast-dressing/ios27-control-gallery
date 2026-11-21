import XCTest
@testable import ControlGallery

final class GalleryCatalogTests: XCTestCase {

    func testTextStylesAreUniqueAndComplete() {
        XCTAssertEqual(GalleryCatalog.textStyles.count, 13)
        let ids = Set(GalleryCatalog.textStyles.map { $0.id })
        XCTAssertEqual(ids.count, GalleryCatalog.textStyles.count)
        XCTAssertTrue(ids.contains("largeTitle"))
        XCTAssertTrue(ids.contains("body"))
        XCTAssertTrue(ids.contains("caption2"))
    }

    func testDynamicTypeLevelsAreOrdered() {
        XCTAssertEqual(GalleryCatalog.dynamicTypes.count, 12)
        XCTAssertEqual(GalleryCatalog.dynamicTypes.first?.id, "xSmall")
        XCTAssertEqual(GalleryCatalog.dynamicTypes.last?.id, "accessibility5")
    }

    func testSpacingScaleIsAscending() {
        let values = GalleryCatalog.spacing.map { $0.value }
        XCTAssertEqual(values, values.sorted())
        XCTAssertEqual(values.first, 4)
        XCTAssertEqual(values.last, 64)
    }

    func testControlSizesCoverEveryStep() {
        XCTAssertEqual(GalleryCatalog.controlSizes.count, 5)
        XCTAssertEqual(GalleryCatalog.controlSizes.first?.id, "mini")
        XCTAssertEqual(GalleryCatalog.controlSizes.last?.id, "extraLarge")
    }

    func testColorPalettesAreSane() {
        XCTAssertGreaterThanOrEqual(GalleryCatalog.systemColors.count, 13)
        XCTAssertEqual(GalleryCatalog.tintColors.count, 10)
        XCTAssertFalse(GalleryCatalog.semanticForegroundColors.isEmpty)
        XCTAssertFalse(GalleryCatalog.semanticBackgroundColors.isEmpty)
        XCTAssertTrue(GalleryCatalog.semanticForegroundColors.allSatisfy { $0.isSemantic })
    }

    func testStoreClampsOutOfRangeValues() {
        let store = GalleryStore()
        store.tintIndex = 99
        XCTAssertEqual(store.clampedTintIndex, GalleryCatalog.tintColors.count - 1)
        store.tintIndex = -5
        XCTAssertEqual(store.clampedTintIndex, 0)

        store.fontDesignIndex = 42
        XCTAssertEqual(store.fontDesign, GalleryCatalog.fontDesigns.last?.design)

        store.dynamicTypeIndex = 99
        XCTAssertEqual(store.dynamicTypeName, GalleryCatalog.dynamicTypes.last?.id)

        store.controlSizeIndex = -1
        XCTAssertEqual(store.controlSizeName, GalleryCatalog.controlSizes.first?.id)
    }

    func testSpacingScalingFollowsStore() {
        let store = GalleryStore()
        store.spacingScale = 1.5
        XCTAssertEqual(store.spacingValue(16), 24, accuracy: 0.001)
        store.spacingScale = 0.6
        XCTAssertEqual(store.bodySpacing, 9.6, accuracy: 0.001)
    }

    func testLightDarkSchemes() {
        XCTAssertNil(ColorSchemeChoice.system.scheme)
        XCTAssertEqual(ColorSchemeChoice.light.scheme, .light)
        XCTAssertEqual(ColorSchemeChoice.dark.scheme, .dark)
        XCTAssertEqual(ListStyleChoice.allCases.count, 4)
    }
}
