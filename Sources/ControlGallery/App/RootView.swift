import SwiftUI

struct RootView: View {
    @EnvironmentObject private var store: GalleryStore

    var body: some View {
        TabView {
            NavigationStack {
                TypographySection()
            }
            .tabItem { Label("排版", systemImage: "textformat.size") }

            NavigationStack {
                ColorSection()
            }
            .tabItem { Label("配色", systemImage: "paintpalette") }

            NavigationStack {
                SpacingSection()
            }
            .tabItem { Label("间距", systemImage: "square.grid.3x1.below.line.grid.1x2") }

            NavigationStack {
                ControlsSection()
            }
            .tabItem { Label("控件", systemImage: "switch.2") }

            NavigationStack {
                ContainerSection()
            }
            .tabItem { Label("形态", systemImage: "square.on.square") }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(GalleryStore())
}
