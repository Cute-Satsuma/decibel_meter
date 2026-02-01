# 应用名称国际化配置总结

## ✅ 已完成的平台配置

### 1. Android 平台
- ✅ 配置了 12 种语言的 `strings.xml` 文件
- ✅ `AndroidManifest.xml` 使用 `@string/app_name` 引用本地化字符串
- ✅ 支持的语言：
  - 英语 (en) - "CS Decibel Meter"
  - 中文 (zh, zh-rCN, zh-rTW) - "CS 分贝仪"
  - 西班牙语 (es) - "CS Medidor de Decibelios"
  - 印地语 (hi) - "CS डेसिबल मीटर"
  - 阿拉伯语 (ar) - "CS مقياس الديسيبل"
  - 葡萄牙语 (pt) - "CS Medidor de Decibéis"
  - 孟加拉语 (bn) - "CS ডেসিবেল মিটার"
  - 俄语 (ru) - "CS Измеритель Децибел"
  - 日语 (ja) - "CS デシベルメーター"
  - 德语 (de) - "CS Dezibel-Messgerät"

### 2. iOS 平台
- ✅ 创建了 11 种语言的 `InfoPlist.strings` 文件
- ✅ 已将 `InfoPlist.strings` 添加到 Xcode 项目 (`project.pbxproj`)
- ✅ 配置了 `PBXVariantGroup` 包含所有语言变体
- ✅ 添加到 Resources build phase
- ✅ `Info.plist` 中的 `CFBundleDisplayName` 作为默认值
- ✅ 支持的语言与 Android 相同

### 3. macOS 平台
- ✅ 创建了 11 种语言的 `InfoPlist.strings` 文件
- ✅ 已将 `InfoPlist.strings` 添加到 Xcode 项目
- ✅ `Info.plist` 中添加了 `CFBundleDisplayName`
- ✅ 支持的语言与 iOS 相同

### 4. Web 平台
- ✅ 更新了 `web/index.html`：
  - `<title>` 标签：CS Decibel Meter
  - `<meta name="apple-mobile-web-app-title">`：CS Decibel Meter
- ✅ 更新了 `web/manifest.json`：
  - `name`: "CS Decibel Meter"
  - `short_name`: "CS Decibel Meter"
  - `description`: "分贝仪 - 测量环境音量"

## 📝 应用名称列表

| 语言 | 应用名称 |
|------|---------|
| 英语 (en) | CS Decibel Meter |
| 中文简体 (zh-CN) | CS 分贝仪 |
| 中文繁体 (zh-TW) | CS 分贝仪 |
| 西班牙语 (es) | CS Medidor de Decibelios |
| 印地语 (hi) | CS डेसिबल मीटर |
| 阿拉伯语 (ar) | CS مقياس الديسيبل |
| 葡萄牙语 (pt) | CS Medidor de Decibéis |
| 孟加拉语 (bn) | CS ডেসিবেল মিটার |
| 俄语 (ru) | CS Измеритель Децибел |
| 日语 (ja) | CS デシベルメーター |
| 德语 (de) | CS Dezibel-Messgerät |

## 🔧 验证步骤

### Android
```bash
flutter build apk --release
# 安装到中文系统的 Android 设备，应用名称应显示为 "CS 分贝仪"
```

### iOS
```bash
flutter clean
flutter build ios --release
# 安装到中文系统的 iOS 设备，应用名称应显示为 "CS 分贝仪"
```

### macOS
```bash
flutter build macos --release
# 在中文系统的 macOS 上运行，应用名称应显示为 "CS 分贝仪"
```

### Web
```bash
flutter build web
# 在浏览器中打开，标题和应用名称应为 "CS Decibel Meter"
```

## ⚠️ 重要提示

1. **重新构建**：修改本地化配置后，需要完全重新构建应用才能生效
2. **清除缓存**：建议运行 `flutter clean` 后再构建
3. **系统语言**：应用名称会根据设备的系统语言自动切换
4. **回退机制**：如果系统语言不在支持列表中，会回退到英语（默认语言）

## 📁 文件位置

- Android: `android/app/src/main/res/values-*/strings.xml`
- iOS: `ios/Runner/*.lproj/InfoPlist.strings`
- macOS: `macos/Runner/*.lproj/InfoPlist.strings`
- Web: `web/index.html`, `web/manifest.json`
