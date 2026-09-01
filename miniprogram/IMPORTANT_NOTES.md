# 重要说明

## ⚠️ 音频分析实现

**当前版本使用模拟数据**，需要实现真实的音频分析功能。

### 问题

微信小程序的 `RecorderManager` API 不直接提供音频振幅数据。`onFrameRecorded` 回调虽然可以获取音频帧数据，但需要额外的音频处理才能计算出分贝值。

### 解决方案

#### 方案一：使用音频处理库（推荐）

1. 使用 `onFrameRecorded` 获取音频帧数据
2. 使用音频处理库（如 `pcm-player` 或自定义 FFT 算法）分析音频
3. 计算 RMS（均方根）值并转换为分贝

示例代码结构：
```javascript
recorderManager.onFrameRecorded((res) => {
  const frameBuffer = res.frameBuffer; // ArrayBuffer
  // 转换为 Float32Array
  const audioData = new Float32Array(frameBuffer);
  // 计算 RMS
  const rms = calculateRMS(audioData);
  // 转换为分贝
  const db = rmsToDb(rms);
  this.updateDecibel(db);
});
```

#### 方案二：后端处理

1. 录音完成后上传录音文件到服务器
2. 服务器使用音频处理库分析音频
3. 返回分贝值给小程序

#### 方案三：使用第三方服务

使用专业的音频分析服务 API。

### 当前实现

`pages/index/index.js` 中的 `processAudioFrame` 方法目前使用模拟数据。需要替换为真实的音频分析逻辑。

## 📝 待完成事项

- [ ] 实现真实的音频分析算法
- [ ] 添加多语言支持
- [ ] 准备图标资源（images/ 目录）
- [ ] 配置小程序 AppID
- [ ] 测试在不同设备上的表现

## 🖼️ 需要的图片资源

在 `miniprogram/images/` 目录下需要准备以下图片：

- `mic.png` / `mic-active.png` - 48x48px，麦克风图标
- `history.png` / `history-active.png` - 48x48px，历史记录图标
- `info.png` - 40x40px，信息图标（红色）
- `stop.png` - 40x40px，停止图标（白色）
- `empty.png` - 128x128px，空状态图标

可以使用 Flutter 版本的图标资源进行转换。

## 🔧 配置说明

1. **AppID 配置**：在 `project.config.json` 中修改 `appid` 字段
2. **权限配置**：录音权限已在 `app.json` 中配置
3. **页面路由**：使用 tabBar 导航，包含"测量"和"历史"两个标签页

## 📱 功能特性

- ✅ 实时分贝显示（当前为模拟数据）
- ✅ 3秒延迟测量机制
- ✅ 统计信息计算和显示
- ✅ 历史记录保存和查看
- ✅ 分页加载历史记录
- ✅ 删除记录功能
- ✅ 根据分贝值显示不同颜色

## 🚀 快速开始

1. 使用微信开发者工具打开 `miniprogram` 目录
2. 配置 AppID（测试可以使用测试号）
3. 准备图片资源
4. 编译运行

## ⚠️ 注意事项

- 当前音频分析使用模拟数据，需要实现真实算法
- 本地存储限制：最多保存 1000 条记录
- 需要用户授权录音权限才能使用
