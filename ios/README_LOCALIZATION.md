# iOS 本地化配置说明

为了让应用名称在中文系统中正确显示，需要在 Xcode 中添加 InfoPlist.strings 文件：

## 方法 1：使用 Xcode（推荐）

1. 在 Xcode 中打开项目：`ios/Runner.xcworkspace`
2. 在项目导航器中，右键点击 `Runner` 文件夹
3. 选择 "Add Files to Runner..."
4. 选择所有语言的 `.lproj` 文件夹中的 `InfoPlist.strings` 文件：
   - en.lproj/InfoPlist.strings
   - zh-Hans.lproj/InfoPlist.strings
   - zh-Hant.lproj/InfoPlist.strings
   - es.lproj/InfoPlist.strings
   - hi.lproj/InfoPlist.strings
   - ar.lproj/InfoPlist.strings
   - pt.lproj/InfoPlist.strings
   - bn.lproj/InfoPlist.strings
   - ru.lproj/InfoPlist.strings
   - ja.lproj/InfoPlist.strings
   - de.lproj/InfoPlist.strings
5. 确保选择 "Create groups"（不是 "Create folder references"）
6. 确保勾选 "Copy items if needed"（如果文件不在项目目录中）
7. 点击 "Add"

## 方法 2：使用命令行工具

运行以下命令自动添加：

```bash
cd ios
# 使用 xcodebuild 或手动编辑 project.pbxproj
```

## 验证

添加后，重新构建应用：
```bash
flutter clean
flutter build ios --release
```

应用名称应该会根据系统语言正确显示。
