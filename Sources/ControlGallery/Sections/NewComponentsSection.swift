import Foundation
import SwiftUI

struct NewComponentsSection: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SectionHeader(
                    title: "数字与拨盘",
                    subtitle: "数字跳动计数 · 刻度滑块（系统 SliderTick）· 相机式调节盘（含 API 名称，代码随参数实时变化）"
                )
                CounterBlock()
                TickSliderBlock()
                CameraDialBlock()
            }
            .padding(16)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("数字")
    }
}

// MARK: - 数字跳动

struct CounterBlock: View {
    @State private var count = 0
    @State private var autoIncrement = false

    private var numericValue: String { "\(count)" }

    private var code: String {
        [
            "Text(\"\\(count)\")",
            "    .contentTransition(.numericText(value: \(numericValue)))",
            "    .animation(.snappy, value: count)",
            "",
            "// 加减时包在 withAnimation 里：",
            "Button(\" +1 \") { withAnimation { count += 1 } }",
            "",
            "// 向下计数用 countsDown: true",
            "Text(\"\\(count)\").contentTransition(.numericText(countsDown: true))"
        ].joined(separator: "\n")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            APICaption(api: "ContentTransition.numericText(value:) · withAnimation · Text", note: "无独立 Counter 类型")

            GalleryCard {
                HStack {
                    Text("当前值")
                        .font(.headline)
                    Spacer()
                    Text("\(count)")
                        .font(.system(size: 44, weight: .semibold, design: .rounded))
                        .monospacedDigit()
                        .contentTransition(.numericText(value: Double(count)))
                        .animation(.snappy(duration: 0.35), value: count)
                }

                HStack(spacing: 12) {
                    Button {
                        withAnimation(.snappy) { count -= 1 }
                    } label: {
                        Label("减一", systemImage: "minus")
                    }
                    .buttonStyle(.bordered)

                    Button {
                        withAnimation(.snappy) { count += 1 }
                    } label: {
                        Label("加一", systemImage: "plus")
                    }
                    .buttonStyle(.borderedProminent)

                    Button("归零") {
                        withAnimation(.snappy) { count = 0 }
                    }
                    .buttonStyle(.borderless)
                }

                Toggle("自动递增（每 0.6 秒）", isOn: $autoIncrement)
                    .controlSize(.small)

                Text("数字变化时走 .numericText 的滚动动画，位数对齐、上下方向可切换。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            CodeBlock(api: "Text · contentTransition(_:) · ContentTransition.numericText", code: code)
        }
        .task(id: autoIncrement) {
            guard autoIncrement else { return }
            while autoIncrement && !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(600))
                guard !Task.isCancelled, autoIncrement else { return }
                withAnimation(.snappy(duration: 0.35)) { count += 1 }
            }
        }
    }
}

// MARK: - 刻度滑块

struct TickSliderBlock: View {
    @State private var value: Double = 0
    @State private var stepped: Double = 0.6

    private var valueText: String { String(format: "%.0f", value) }
    private var stepText: String { String(format: "%.1f", stepped) }

    private var code: String {
        [
            "// iOS 26+：Slider 原生支持刻度线",
            "Slider(value: $value, in: -3...3,",
            "       label: { Text(\"曝光补偿\") },",
            "       currentValueLabel: { Text(\"\(valueText)\") },",
            "       ticks: {",
            "    SliderTick(-3.0)",
            "    SliderTick(-2.0)",
            "    SliderTick(-1.0, label: { Text(\"−1\") })",
            "    SliderTick(0.0, label: { Text(\"0\") })",
            "    SliderTick(1.0, label: { Text(\"+1\") })",
            "    SliderTick(2.0)",
            "    SliderTick(3.0)",
            "})",
            "",
            "// 逐 step 自动生成刻度：tick 闭包",
            "Slider(value: $stepped, in: 0...1, step: 0.1,",
            "       label: { Text(\"精细刻度\") }, tick: { SliderTick($0) })",
            "",
            "// 中性点 / 有效区间（相机语义）",
            "Slider(value: $value, in: -3...3, neutralValue: 0,",
            "       enabledBounds: -2...2, label: { … })"
        ].joined(separator: "\n")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            APICaption(api: "Slider(ticks:) · SliderTick · SliderTickContentForEach · neutralValue / enabledBounds", note: "iOS 26+")

            GalleryCard {
                HStack {
                    Text("带刻度线").font(.headline)
                    Spacer()
                    ValuePill(text: valueText)
                }

                Slider(
                    value: $value,
                    in: -3...3,
                    label: { Text("曝光补偿") },
                    currentValueLabel: { Text(valueText) },
                    minimumValueLabel: { Text("-3") },
                    maximumValueLabel: { Text("+3") },
                    ticks: {
                        SliderTick(-3.0)
                        SliderTick(-2.0)
                        SliderTick(-1.0, label: { Text("−1") })
                        SliderTick(0.0, label: { Text("0") })
                        SliderTick(1.0, label: { Text("+1") })
                        SliderTick(2.0)
                        SliderTick(3.0)
                    }
                )

                Divider()

                HStack {
                    Text("逐 step 生成刻度").font(.headline)
                    Spacer()
                    ValuePill(text: stepText)
                }

                Slider(
                    value: $stepped,
                    in: 0...1,
                    step: 0.1,
                    label: { Text("精细刻度") },
                    tick: { SliderTick($0) }
                )

                Divider()

                HStack {
                    Text("中性点 / 有效区间").font(.headline)
                    Spacer()
                    ValuePill(text: "neutral 0")
                }

                Slider(
                    value: $value,
                    in: -3...3,
                    step: 0.5,
                    neutralValue: 0,
                    enabledBounds: -2...2,
                    label: { Text("相机曝光") },
                    minimumValueLabel: { Text("−3") },
                    maximumValueLabel: { Text("+3") }
                )

                Text("neutralValue 给滑块一个中性中心，enabledBounds 只让区间内可选，超出部分灰掉——相机调节盘的语义。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            CodeBlock(api: "Slider · SliderTick · SliderTickContent", code: code)
        }
    }
}

// MARK: - 相机式调节盘

struct CameraDialBlock: View {
    @State private var pearl: Double = 32

    private var pearlText: String { String(format: "%.0f", pearl) }
    private var angleText: String { String(format: "%.0f", pearl * 3.3) }

    private var code: String {
        [
            "// 系统没有 Dial / Knob 组件，用 DragGesture 自绘：",
            "GeometryReader { geo in",
            "    let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)",
            "    ZStack { ticks; knob }",
            "        .gesture(",
            "            DragGesture(minimumDistance: 0).onChanged { value in",
            "                let dx = value.location.x - center.x",
            "                let dy = value.location.y - center.y",
            "                var deg = atan2(dy, dx) * 180 / .pi + 90",
            "                if deg < 0 { deg += 360 }",
            "                pearl = min(100, max(0, deg / 3.6))",
            "            }",
            "        )",
            "}",
            ".rotationEffect(.degrees(\(angleText)))",
            ".sensoryFeedback(.selection, trigger: Int(pearl))   // 每格一次触感",
            "",
            "// 想要系统语义，可退一步用：",
            "// Gauge(value:).gaugeStyle(.accessoryCircular) 或 Slider(neutralValue:)"
        ].joined(separator: "\n")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            APICaption(api: "DragGesture · atan2 · rotationEffect · sensoryFeedback", note: "自绘（无系统组件）")

            GalleryCard {
                HStack(spacing: 16) {
                    dial
                        .frame(width: 148, height: 148)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("珠光强度").font(.headline)
                        Text(pearlText)
                            .font(.system(size: 34, weight: .semibold, design: .rounded))
                            .monospacedDigit()
                            .contentTransition(.numericText(value: pearl))
                        Text("0 – 100，按角度映射")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [.white, Color.blue.opacity(0.35), .purple.opacity(0.5)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 26)
                            .overlay {
                                Text("珠光预览")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                    }
                }

                Text("拖动圆盘任意位置即可调节（角度跟随手指），松手后停在当前值；下方滑杆用于微调。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Slider(
                    value: $pearl,
                    in: 0...100,
                    step: 1,
                    label: { Text("微调") },
                    ticks: {
                        SliderTick(0.0)
                        SliderTick(50.0)
                        SliderTick(100.0)
                    }
                )
            }

            CodeBlock(api: "DragGesture · GeometryReader · rotationEffect · sensoryFeedback(.selection)", code: code)
        }
        .sensoryFeedback(.selection, trigger: Int(pearl))
    }

    private var dial: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = min(geo.size.width, geo.size.height) / 2

            ZStack {
                Circle()
                    .strokeBorder(Color.secondary.opacity(0.18), lineWidth: 1)

                ForEach(0..<40, id: \.self) { index in
                    Capsule()
                        .fill(index % 5 == 0 ? Color.primary.opacity(0.55) : Color.secondary.opacity(0.3))
                        .frame(width: 1.5, height: index % 5 == 0 ? 12 : 6)
                        .offset(y: -(radius - 8))
                        .rotationEffect(.degrees(Double(index) * 9))
                }

                Capsule()
                    .fill(Color.accentColor)
                    .frame(width: 3, height: radius * 0.34)
                    .offset(y: -(radius * 0.42))
                    .rotationEffect(.degrees(pearl * 3.6))

                Circle()
                    .fill(.thinMaterial)
                    .frame(width: radius * 0.92, height: radius * 0.92)
                    .overlay {
                        Text(pearlText)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .monospacedDigit()
                    }
            }
            .contentShape(Circle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        let dx = value.location.x - center.x
                        let dy = value.location.y - center.y
                        var degrees = atan2(dy, dx) * 180 / .pi + 90
                        if degrees < 0 { degrees += 360 }
                        pearl = min(100, max(0, degrees / 3.6))
                    }
            )
        }
    }
}
