# 控件图鉴 · iOS 27 SwiftUI

用 **Xcode 27.2 / iOS 27.2 SDK** 构建的 SwiftUI 示例 App，把 iOS 的系统控件、系统字号、默认间距与系统配色集中展示；多形态控件通过滑块或 Picker 即时切换。

## 内容

| 页面 | 内容 |
| --- | --- |
| 排版 | 11 级 iOS 可用系统文本样式（largeTitle → caption2）、12 档 Dynamic Type 滑块、字体设计 4 种、字重 9 档 |
| 配色 | 13 个系统强调色、7 个语义前景色、9 个语义背景色、浅色/深色/跟随系统切换、tint 即时切换 |
| 间距 | 4–64pt 间距阶梯、控件尺寸 5 档（mini→extraLarge）滑块、圆角与按钮边框形状 |
| 控件 | Button、Toggle、Slider、Stepper、Picker（menu/segmented/wheel/inline）、DatePicker、ColorPicker、ProgressView、Gauge、TextField、SecureField、TextEditor、Label、Link、ShareLink、DisclosureGroup、ControlGroup、Symbol Effects、Alert、ConfirmationDialog、Sheet、Popover |
| 形态 | GroupBox、Grid、LazyVGrid、横向 ScrollView、分页 TabView、NavigationLink、列表样式切换、关于页 |

## 构建

CI 由 [ios-ci-workflows](https://github.com/wenjinliuu/ios-ci-workflows) 的约定驱动：`.ios-ci.yml` 保存全部设置，`.github/workflows/build-test.yml` 是薄入口，具体命令在 `ci/build.sh`。

- runner：`xcode-27`（macOS 27 + Xcode 27.2，Apple Silicon）
- 工具链：`/Applications/Xcode_27.2.app`，iOS 27.2 SDK，模拟器 iPhone 18 Pro (iOS 27.2)
- 工程：XcodeGen 2.46.0 生成 `ControlGallery.xcodeproj`
- 产物：Release、**无签名** `ControlGallery-unsigned.ipa`，同时上传 Actions artifact 与 Release `unsigned-ipa`（构建日志在 Release `ci-logs`）

本地不需要 Mac；改代码 push 后读 Actions 的 Build & Test 报告。

> 与中央可复用工作流的差异：中央的 test job 固定在 `macos-26`，而 Xcode 27.2 只装在 `xcode-27` 镜像（macOS 27）里，所以本仓库在 `ci/build.sh` 就地实现 Build & Test，仍以 `.ios-ci.yml` 为唯一配置源。

## 结构

```
.ios-ci.yml                      # ios-ci-workflows 配置（xcode 27.2 / ios 27.2）
project.yml                      # XcodeGen 工程描述
ci/build.sh                      # 选 Xcode、生成、测试、无签名归档、打包 IPA
Sources/ControlGallery/
  App/                           # 入口与 Tab 根视图
  Models/                        # 设计令牌目录 + 全局状态
  Sections/                      # 排版/配色/间距/控件/形态/关于
  Components/                    # 卡片、标题、数值胶囊
Tests/ControlGalleryTests/       # 设计令牌与状态钳制的单元测试
```
