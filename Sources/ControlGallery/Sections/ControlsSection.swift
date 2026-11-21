import SwiftUI

struct ControlsSection: View {
    @State private var searchText = ""

    var body: some View {
        List {
            ButtonsBlock()
            TogglesBlock()
            ValueControlsBlock()
            PickersBlock()
            DateTimeColorBlock()
            ProgressBlock()
            TextInputBlock()
            LabelsLinksBlock()
            StructureBlock()
            PresentationBlock()
        }
        .listStyle(.insetGrouped)
        .searchable(text: $searchText, prompt: "搜索控件名")
        .navigationTitle("控件")
    }
}

// MARK: - 按钮

struct ButtonsBlock: View {
    @EnvironmentObject private var store: GalleryStore

    private var code: String {
        [
            "Button(\"主要操作\") { }",
            "    .buttonStyle(.borderedProminent)",
            "    \(store.buttonBorderShapeSample)",
            "    \(store.controlSizeModifier)",
            "    \(store.tintModifier)"
        ].joined(separator: "\n")
    }

    var body: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    Button("默认") {}
                    Button("Filled") {}.buttonStyle(.borderedProminent)
                    Button("Bordered") {}.buttonStyle(.bordered)
                    Button("Borderless") {}.buttonStyle(.borderless)
                    Button {} label: {
                        Label("分享", systemImage: "square.and.arrow.up")
                    }
                    .buttonStyle(.bordered)
                    Button(role: .destructive) {} label: {
                        Label("删除", systemImage: "trash")
                    }
                    Button {} label: {
                        Image(systemName: "heart.fill")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .controlSize(store.controlSize)
                .buttonBorderShape(.roundedRectangle(radius: min(store.cornerRadius, 22)))
            }
            .padding(.vertical, 4)

            HStack(spacing: 10) {
                Button("小") {}.controlSize(.small)
                Button("常规") {}.controlSize(.regular)
                Button("大") {}.controlSize(.large)
                Button("特大") {}.controlSize(.extraLarge)
            }
            .buttonStyle(.bordered)

            Button {
            } label: {
                Label("整行宽度按钮", systemImage: "rectangle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            CodeBlock(api: "Button · ButtonStyle · ControlSize", code: code)
        } header: {
            Text("按钮 Button")
        } footer: {
            Text("当前 controlSize = \(store.controlSizeName)，边框形状跟随圆角设置。")
        }
    }
}

// MARK: - 开关

struct TogglesBlock: View {
    @State private var switchOn = true
    @State private var buttonOn = true
    @State private var borderedOn = false

    private var code: String {
        let state = switchOn ? "开" : "关"
        return [
            "Toggle(\"Switch 样式\", isOn: $switchOn)   // 当前：\(state)",
            "Toggle(\"Button 样式\", isOn: $buttonOn)",
            "    .toggleStyle(.button)",
            "Toggle(\"图标开关\", isOn: $switchOn)",
            "    .toggleStyle(.button)",
            "    .tint(.pink)"
        ].joined(separator: "\n")
    }

    var body: some View {
        Section("开关 Toggle") {
            Toggle("Switch 样式", isOn: $switchOn)
            Toggle("Button 样式", isOn: $buttonOn)
                .toggleStyle(.button)
            Toggle("Button + bordered", isOn: $borderedOn)
                .toggleStyle(.button)
                .buttonStyle(.bordered)
            Toggle("图标开关", isOn: $switchOn)
                .toggleStyle(.button)
                .tint(.pink)

            CodeBlock(api: "Toggle · ToggleStyle", code: code)
        }
    }
}

// MARK: - 滑块与步进器

struct ValueControlsBlock: View {
    @State private var value: Double = 0.42
    @State private var stepped: Double = 3
    @State private var count = 3

    private var code: String {
        let fraction = String(format: "%.2f", value)
        let integer = String(format: "%.0f", stepped)
        return [
            "Slider(value: $value)                  // 当前值 \(fraction)",
            "Slider(value: $stepped, in: 0...10, step: 1)   // 当前值 \(integer)",
            "Stepper(\"数量\", value: $count, in: 0...10)   // 当前值 \(count)"
        ].joined(separator: "\n")
    }

    var body: some View {
        Section("滑块 Slider / 步进器 Stepper") {
            Slider(value: $value)
                .accessibilityLabel("连续滑块")
            HStack {
                ControlCaption(text: "0")
                Spacer()
                Text(String(format: "%.2f", value))
                    .font(.caption2)
                    .monospacedDigit()
            }
            Slider(value: $stepped, in: 0...10, step: 1) {
                Text("步长 1")
            }
            Slider(value: $value, in: 0...1, step: 0.25) {
                Text("步长 0.25")
            }
            .tint(.orange)

            Stepper("数量：\(count)", value: $count, in: 0...10)
            Stepper(value: $count, in: 0...10) {
                Label("带标签的步进器", systemImage: "plusminus.circle")
                    .labelStyle(.titleAndIcon)
            }

            CodeBlock(api: "Slider · Stepper", code: code)
        }
    }
}

// MARK: - 选择器

struct PickersBlock: View {
    @State private var picked = "轻触"
    @State private var segment = 1

    private let options = ["轻触", "拖动", "长按"]

    private var code: String {
        let segmentText = "\(segment)"
        return [
            "Picker(\"菜单\", selection: $picked) { … }        // 当前：\(picked)",
            "Picker(\"分段\", selection: $segment) { … }",
            "    .pickerStyle(.segmented)                    // 当前：\(segmentText)",
            "Picker(\"滚轮\", selection: $segment) { … }",
            "    .pickerStyle(.wheel)",
            "Picker(\"内联\", selection: $picked) { … }",
            "    .pickerStyle(.inline)"
        ].joined(separator: "\n")
    }

    var body: some View {
        Section("选择器 Picker") {
            Picker("菜单样式", selection: $picked) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }

            Picker("分段样式", selection: $segment) {
                Text("日").tag(0)
                Text("周").tag(1)
                Text("月").tag(2)
            }
            .pickerStyle(.segmented)

            Picker("滚轮样式", selection: $segment) {
                Text("日").tag(0)
                Text("周").tag(1)
                Text("月").tag(2)
            }
            .pickerStyle(.wheel)
            .frame(height: 108)

            Picker("内联样式", selection: $picked) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.inline)

            CodeBlock(api: "Picker · PickerStyle", code: code)
        }
    }
}

// MARK: - 日期与颜色

struct DateTimeColorBlock: View {
    @State private var date = Date()
    @State private var color = Color.blue

    private var code: String {
        [
            "DatePicker(\"日期\", selection: $date, displayedComponents: .date)",
            "DatePicker(\"图形\", selection: $date, displayedComponents: .date)",
            "    .datePickerStyle(.graphical)",
            "ColorPicker(\"颜色\", selection: $color, supportsOpacity: true)",
            "ColorPicker(\"不带透明度\", selection: $color, supportsOpacity: false)"
        ].joined(separator: "\n")
    }

    var body: some View {
        Section("日期 DatePicker / 颜色 ColorPicker") {
            DatePicker("日期（紧凑）", selection: $date, displayedComponents: .date)
            DatePicker("时间", selection: $date, displayedComponents: .hourAndMinute)
            DatePicker("图形日历", selection: $date, displayedComponents: .date)
                .datePickerStyle(.graphical)
            ColorPicker("颜色（含透明度）", selection: $color, supportsOpacity: true)
            ColorPicker("颜色（不含透明度）", selection: $color, supportsOpacity: false)

            CodeBlock(api: "DatePicker · DatePickerStyle · ColorPicker", code: code)
        }
    }
}

// MARK: - 进度与仪表

struct ProgressBlock: View {
    @State private var progress: Double = 0.35
    @State private var gaugeValue: Double = 0.62

    private var code: String {
        let progressText = String(format: "%.2f", progress)
        let gaugeText = String(format: "%.2f", gaugeValue)
        let percent = Int(progress * 100)
        return [
            "ProgressView(value: \(progressText))            // 当前 \(percent)%",
            "ProgressView()                                  // 不确定态",
            "Gauge(value: \(gaugeText)) { Text(\"容量\") }",
            "    .gaugeStyle(.linearCapacity)",
            "Gauge(value: \(gaugeText)) { … }",
            "    .gaugeStyle(.accessoryCircularCapacity)"
        ].joined(separator: "\n")
    }

    var body: some View {
        Section("进度 ProgressView / 仪表 Gauge") {
            ProgressView(value: progress)
            ProgressView(value: progress) {
                Text("上传")
            } currentValueLabel: {
                Text("\(Int(progress * 100))%")
            }

            HStack(spacing: 16) {
                ProgressView()
                ProgressView(value: progress)
                    .progressViewStyle(.circular)
                Spacer()
                Text("圆形 / 不确定态")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Slider(value: $progress)

            Gauge(value: gaugeValue) {
                Text("容量")
            } currentValueLabel: {
                Text("\(Int(gaugeValue * 100))%")
            }
            .gaugeStyle(.linearCapacity)
            .tint(.green)

            HStack(spacing: 20) {
                Gauge(value: gaugeValue) {
                    Image(systemName: "gauge.with.dots.needle.bottom.50percent")
                }
                .gaugeStyle(.accessoryCircular)

                Gauge(value: gaugeValue) {
                    Text("CPU")
                } currentValueLabel: {
                    Text("62")
                }
                .gaugeStyle(.accessoryCircularCapacity)
                .tint(.orange)

                Gauge(value: gaugeValue) {
                    Text("磁盘")
                }
                .gaugeStyle(.accessoryLinearCapacity)
            }

            Slider(value: $gaugeValue)

            CodeBlock(api: "ProgressView · ProgressViewStyle · Gauge · GaugeStyle", code: code)
        }
    }
}

// MARK: - 文本输入

struct TextInputBlock: View {
    @State private var singleLine = "单行文本"
    @State private var email = "hello@example.com"
    @State private var secret = "密码"
    @State private var multiline = "多行输入"
    @State private var notes = "TextEditor：多行文本编辑器，可滚动。"

    private var code: String {
        let current = singleLine
        return [
            "TextField(\"单行\", text: $singleLine)   // 当前：\(current)",
            "TextField(\"邮箱\", text: $email)",
            "    .keyboardType(.emailAddress)",
            "    .textInputAutocapitalization(.never)",
            "SecureField(\"密码\", text: $secret)",
            "TextField(\"多行\", text: $multiline, axis: .vertical)",
            "    .lineLimit(1...3)",
            "TextEditor(text: $notes)"
        ].joined(separator: "\n")
    }

    var body: some View {
        Section("文本输入 TextField / TextEditor") {
            TextField("单行文本", text: $singleLine)
            TextField("邮箱", text: $email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            SecureField("密码", text: $secret)
            TextField("多行 TextField", text: $multiline, axis: .vertical)
                .lineLimit(1...3)
            TextEditor(text: $notes)
                .frame(height: 92)
                .font(.footnote)
                .scrollContentBackground(.hidden)
                .background(Color(uiColor: .tertiarySystemFill), in: RoundedRectangle(cornerRadius: 8))

            CodeBlock(api: "TextField · SecureField · TextEditor", code: code)
        }
    }
}

// MARK: - 标签与链接

struct LabelsLinksBlock: View {
    @State private var tapped = 0

    private var code: String {
        [
            "Label(\"系统标签\", systemImage: \"tag.fill\")",
            "    .labelStyle(.titleAndIcon)      // .iconOnly / .titleOnly",
            "LabeledContent(\"版本\", value: \"1.0\")",
            "Link(\"Apple Developer\", destination: URL(string: \"https://developer.apple.com\")!)",
            "ShareLink(item: \"iOS 27 控件图鉴\")   // 已点击 \(tapped) 次"
        ].joined(separator: "\n")
    }

    var body: some View {
        Section("标签 Label / 链接 Link / 分享 ShareLink") {
            Label("系统标签", systemImage: "tag.fill")
            Label("仅图标", systemImage: "bell.fill")
                .labelStyle(.iconOnly)
            Label("仅标题", systemImage: "bell.fill")
                .labelStyle(.titleOnly)
            LabeledContent("存储占用", value: "128 MB")
            LabeledContent("版本", value: "1.0")

            Link("Apple Developer", destination: URL(string: "https://developer.apple.com")!)

            ShareLink(item: "iOS 27 控件图鉴") {
                Label("分享文本", systemImage: "square.and.arrow.up")
            }

            Button {
                tapped += 1
            } label: {
                Label("点击了 \(tapped) 次", systemImage: "hand.tap")
            }
            .buttonStyle(.bordered)

            CodeBlock(api: "Label · LabeledContent · Link · ShareLink", code: code)
        }
    }
}

// MARK: - 结构型控件

struct StructureBlock: View {
    @State private var expanded = false
    @State private var symbolOn = true

    private var code: String {
        let expandState = expanded ? "展开" : "收起"
        return [
            "DisclosureGroup(\"高级选项\", isExpanded: $expanded) { … }   // 当前：\(expandState)",
            "ControlGroup { Button(\"上一步\") {}; Button(\"下一步\") {} }",
            "Image(systemName: \"wifi\")",
            "    .symbolEffect(.variableColor.iterative, isActive: \(symbolOn))",
            "HStack { … }",
            "    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))"
        ].joined(separator: "\n")
    }

    var body: some View {
        Section("结构 DisclosureGroup / ControlGroup / 材料") {
            DisclosureGroup("高级选项", isExpanded: $expanded) {
                Toggle("跟随系统外观", isOn: $symbolOn)
                Text("DisclosureGroup 用于折叠次要内容。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            ControlGroup {
                Button("上一步") {}
                Button("下一步") {}
            }

            HStack(spacing: 14) {
                Image(systemName: "wifi")
                    .font(.title3)
                    .symbolEffect(.variableColor.iterative, isActive: symbolOn)
                Image(systemName: "bell.fill")
                    .font(.title3)
                    .symbolEffect(.bounce, value: symbolOn)
                Image(systemName: "heart.fill")
                    .font(.title3)
                    .foregroundStyle(.pink)
                    .symbolEffect(.pulse, value: expanded)
                Spacer()
                Text("Symbol Effects")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)

            HStack {
                Text("Material")
                    .font(.subheadline)
                Spacer()
                Text("thin / regular")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            CodeBlock(api: "DisclosureGroup · ControlGroup · SymbolEffect · Material", code: code)
        }
    }
}

// MARK: - 模态与提示

struct PresentationBlock: View {
    @State private var showAlert = false
    @State private var showDialog = false
    @State private var showSheet = false
    @State private var showPopover = false

    private var code: String {
        [
            ".alert(\"系统 Alert\", isPresented: $showAlert) { … }",
            ".confirmationDialog(\"确认删除？\", isPresented: $showDialog) { … }",
            ".sheet(isPresented: $showSheet) { … }",
            "    .presentationDetents([.medium, .large])",
            ".popover(isPresented: $showPopover) { … }",
            "    .presentationCompactAdaptation(.popover)"
        ].joined(separator: "\n")
    }

    var body: some View {
        Section("模态 Alert / Dialog / Sheet / Popover") {
            Button("Alert 提示") { showAlert = true }
                .alert("系统 Alert", isPresented: $showAlert) {
                    Button("取消", role: .cancel) {}
                    Button("确定") {}
                } message: {
                    Text("Alert 用于需要用户确认的短提示。")
                }

            Button("Confirmation Dialog") { showDialog = true }
                .confirmationDialog("确认删除？", isPresented: $showDialog, titleVisibility: .visible) {
                    Button("删除", role: .destructive) {}
                    Button("取消", role: .cancel) {}
                }

            Button("Sheet 半屏") { showSheet = true }
                .sheet(isPresented: $showSheet) {
                    NavigationStack {
                        List {
                            Text("Sheet 内容")
                            Text("支持 detents：medium / large")
                        }
                        .navigationTitle("模态页")
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("完成") { showSheet = false }
                            }
                        }
                    }
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
                }

            Button("Popover") { showPopover = true }
                .popover(isPresented: $showPopover) {
                    Text("Popover 内容")
                        .padding()
                        .presentationCompactAdaptation(.popover)
                }

            CodeBlock(api: "alert · confirmationDialog · sheet · popover", code: code)
        }
    }
}
