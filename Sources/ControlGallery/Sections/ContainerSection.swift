import SwiftUI

struct ContainerSection: View {
    @EnvironmentObject private var store: GalleryStore
    @State private var pageIndex = 0

    private var listStyleCode: String {
        [
            "List { … }",
            "    \(store.listStyleSample)"
        ].joined(separator: "\n")
    }

    var body: some View {
        VStack(spacing: 0) {
            Picker("列表样式", selection: $store.listStyleChoice) {
                ForEach(ListStyleChoice.allCases) { style in
                    Text(style.title).tag(style)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            listContent
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("形态")
    }

    @ViewBuilder
    private var listContent: some View {
        switch store.listStyleChoice {
        case .insetGrouped:
            content.listStyle(.insetGrouped)
        case .grouped:
            content.listStyle(.grouped)
        case .plain:
            content.listStyle(.plain)
        case .sidebar:
            content.listStyle(.sidebar)
        }
    }

    private var content: some View {
        List {
            Section("容器 GroupBox") {
                GroupBox("系统 GroupBox") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("GroupBox 用来把相关内容分组。")
                            .font(.subheadline)
                        Text("默认带系统背景与圆角。")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                CodeBlock(
                    api: "GroupBox",
                    code: "GroupBox(\"系统 GroupBox\") {\n    Text(\"内容\")\n}"
                )
            }

            Section("网格 Grid / LazyVGrid") {
                Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                    GridRow {
                        Text("Token").font(.caption).foregroundStyle(.secondary)
                        Text("Value").font(.caption).foregroundStyle(.secondary)
                        Text("Preview").font(.caption).foregroundStyle(.secondary)
                    }
                    Divider()
                    GridRow {
                        Text("spacing")
                        Text("16")
                        RoundedRectangle(cornerRadius: 4).fill(store.tintColor).frame(width: 16, height: 16)
                    }
                    GridRow {
                        Text("radius")
                        Text("\(Int(store.cornerRadius))")
                        RoundedRectangle(cornerRadius: store.cornerRadius / 2)
                            .fill(store.tintColor.opacity(0.6))
                            .frame(width: 24, height: 24)
                    }
                }

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 92), spacing: 8)], spacing: 8) {
                    ForEach(GalleryCatalog.spacing) { token in
                        Text("\(token.id) pt")
                            .font(.caption2)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                            .background(Color(uiColor: .tertiarySystemFill), in: RoundedRectangle(cornerRadius: 6))
                    }
                }

                CodeBlock(
                    api: "Grid · GridRow · LazyVGrid · GridItem",
                    code: "Grid(horizontalSpacing: 12, verticalSpacing: 12) {\n    GridRow { Text(\"Token\"); Text(\"Value\") }\n}\nLazyVGrid(columns: [GridItem(.adaptive(minimum: 92))]) { … }"
                )
            }

            Section("横向滚动 ScrollView") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(GalleryCatalog.systemColors.prefix(10)) { token in
                            VStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(token.color)
                                    .frame(width: 64, height: 64)
                                Text(token.id)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }

                CodeBlock(
                    api: "ScrollView(_:showsIndicators:) · Axis",
                    code: "ScrollView(.horizontal, showsIndicators: false) {\n    HStack(spacing: 10) { … }\n}"
                )
            }

            Section("分页 TabView") {
                TabView(selection: $pageIndex) {
                    pageView(title: "第一页", color: store.tintColor)
                        .tag(0)
                    pageView(title: "第二页", color: .orange)
                        .tag(1)
                    pageView(title: "第三页", color: .teal)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 150)

                CodeBlock(
                    api: "TabView(selection:) · PageTabViewStyle",
                    code: "TabView(selection: $pageIndex) {\n    Text(\"第一页\").tag(0)\n}\n.tabViewStyle(.page(indexDisplayMode: .always))   // 当前第 \(pageIndex + 1) 页"
                )
            }

            Section("导航 NavigationLink") {
                NavigationLink {
                    AboutSection()
                } label: {
                    Label("关于本 App 与工具链", systemImage: "info.circle")
                }

                CodeBlock(
                    api: "NavigationStack · NavigationLink",
                    code: "NavigationStack {\n    NavigationLink(\"关于\") { AboutSection() }\n}"
                )
            }

            Section {
                Text("列表样式由顶部 Picker 切换：insetGrouped / grouped / plain / sidebar，下面的代码同步。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                CodeBlock(api: "ListStyle · View.listStyle(_:)", code: listStyleCode)
            }
        }
    }

    private func pageView(title: String, color: Color) -> some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(color.opacity(0.18))
            .overlay {
                VStack(spacing: 6) {
                    Text(title)
                        .font(.headline)
                    Text("TabView(.page)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 4)
    }
}
