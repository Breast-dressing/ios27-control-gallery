# AI 协作规则

- 本项目用 [ios-ci-workflows](https://github.com/wenjinliuu/ios-ci-workflows) 的约定编译和测试（`.ios-ci.yml` + 薄入口工作流 `.github/workflows/build-test.yml`）；本地不跑 Xcode。改完代码 push，读 Build & Test 的测试报告再修。
- 工具链：Xcode 27.2（`/Applications/Xcode_27.2.app`，iOS 27.2 SDK），runner 用 `xcode-27` 而不是 `macos-26`，因为 Xcode 27.2 只在该镜像里。
- 新功能必须带测试；能用逻辑测试验证的不写成 UI 测试；UI 测试按条件等待，不用 sleep 固定等。
- 删测试只有三种理由：功能已删除、和另一个测试完全重复、已被更便宜的测试覆盖；删测试、改断言的预期值都要在提交里写明理由。
- 有意改了界面：说明改了哪些页面。
- 部署只走 git → CI；MCP 只用来查数据、看日志、排查问题。
- 更多细节见 ios-ci-workflows 的 Skill：skills/ios-ci-workflows/SKILL.md。
