import SwiftUI

@main
struct ControlGalleryApp: App {
    @StateObject private var store = GalleryStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .preferredColorScheme(store.colorScheme)
                .dynamicTypeSize(store.dynamicTypeSize)
                .tint(store.tintColor)
        }
    }
}
