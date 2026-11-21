import SwiftUI

struct ContainerSection: View {
    @EnvironmentObject private var store: GalleryStore
    @State private var pageIndex = 0

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
            }

            Section("导航 NavigationLink") {
                NavigationLink {
                    AboutSection()
                } label: {
                    Label("关于本 App 与工具链", systemImage: "info.circle")
                }
            }

            Section {
                Text("列表样式由顶部 Picker 切换：insetGrouped / grouped / plain / sidebar。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
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
