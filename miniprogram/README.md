# 分贝仪 Caju - 微信小程序版

这是 分贝仪 Caju的微信小程序版本，提供环境音量测量和历史记录功能。

## 功能特性

- ✅ 实时分贝测量
- ✅ 3秒延迟测量机制（确保麦克风稳定）
- ✅ 统计信息显示（最小值、平均值、峰值、百分位值）
- ✅ 历史记录保存和查看
- ✅ 分页加载历史记录
- ✅ 删除记录功能
- ✅ 根据分贝值显示不同颜色

## 项目结构

```
miniprogram/
├── app.js                 # 小程序入口文件
├── app.json              # 小程序全局配置
├── app.wxss              # 小程序全局样式
├── pages/
│   ├── index/            # 主页面（测量页面）
│   │   ├── index.js
│   │   ├── index.wxml
│   │   ├── index.wxss
│   │   └── index.json
│   └── history/          # 历史记录页面
│       ├── history.js
│       ├── history.wxml
│       ├── history.wxss
│       └── history.json
├── images/               # 图片资源目录
│   ├── mic.png           # 麦克风图标
│   ├── mic-active.png    # 麦克风图标（激活）
│   ├── history.png       # 历史记录图标
│   ├── history-active.png # 历史记录图标（激活）
│   ├── info.png          # 信息图标
│   ├── stop.png          # 停止图标
│   └── empty.png         # 空状态图标
├── project.config.json   # 项目配置文件
└── sitemap.json          # 站点地图配置
```

## 使用说明

### 1. 配置 AppID

在 `project.config.json` 中修改 `appid` 为你的小程序 AppID。

### 2. 准备图片资源

需要在 `images/` 目录下准备以下图片：
- `mic.png` / `mic-active.png` - 麦克风图标（48x48px）
- `history.png` / `history-active.png` - 历史记录图标（48x48px）
- `info.png` - 信息图标（40x40px，红色）
- `stop.png` - 停止图标（40x40px，白色）
- `empty.png` - 空状态图标（128x128px）

### 3. 权限配置

在 `app.json` 中已配置录音权限，首次使用时会自动请求用户授权。

### 4. 开发调试

1. 使用微信开发者工具打开 `miniprogram` 目录
2. 配置 AppID（测试可以使用测试号）
3. 编译运行

## 技术说明

### 音频处理

**注意**：当前实现使用了模拟数据。微信小程序的录音 API (`wx.getRecorderManager()`) 不直接提供音频振幅数据。

要实现真实的分贝测量，需要：

1. **方案一**：使用 `RecorderManager.onFrameRecorded` 获取音频帧数据，然后使用 Web Audio API 或音频处理库进行 FFT 分析
2. **方案二**：使用第三方音频处理库（如 `pcm-player` 等）
3. **方案三**：后端处理（将录音文件上传到服务器，服务器分析后返回分贝值）

当前代码中 `processAudioFrame` 方法使用了模拟数据，实际项目中需要替换为真实的音频分析逻辑。

### 数据存储

- 使用微信小程序的本地存储 API (`wx.setStorageSync` / `wx.getStorageSync`)
- 历史记录存储在本地，最多保存 1000 条
- 数据格式与 Flutter 版本保持一致

### 分页加载

- 使用 `scroll-view` 组件的 `bindscrolltolower` 事件实现滚动加载
- 每页加载 20 条记录
- 支持下拉刷新

## 待完善功能

- [ ] 实现真实的音频分析（替换模拟数据）
- [ ] 添加多语言支持
- [ ] 优化 UI 设计
- [ ] 添加数据导出功能
- [ ] 添加数据统计图表

## 注意事项

1. **音频分析**：当前使用模拟数据，需要实现真实的音频分析算法
2. **性能优化**：大量历史记录时可能需要优化渲染性能
3. **兼容性**：确保在不同版本的微信客户端上测试

## 许可证

与主项目保持一致。
