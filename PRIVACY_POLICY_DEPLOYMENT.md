# 隐私政策部署指南

## 概述

Google Play 要求所有应用提供可公开访问的隐私政策网址。本指南将帮助您部署隐私政策文件。

## 文件位置

隐私政策文件已创建在项目根目录：`privacy_policy.html`

## 部署选项

### 选项 1：GitHub Pages（推荐，免费）

1. **将项目推送到 GitHub**
   ```bash
   git add privacy_policy.html
   git commit -m "Add privacy policy"
   git push origin main
   ```

2. **启用 GitHub Pages**
   - 进入您的 GitHub 仓库
   - 点击 Settings（设置）
   - 在左侧菜单中找到 Pages
   - 在 Source 下选择 "Deploy from a branch"
   - 选择 main 分支和 / (root) 目录
   - 点击 Save

3. **访问您的隐私政策**
   - GitHub Pages URL 格式：`https://[您的用户名].github.io/[仓库名]/privacy_policy.html`
   - 例如：`https://username.github.io/decibel_meter/privacy_policy.html`

### 选项 2：使用 GitHub Gist（快速简单）

1. **创建 Gist**
   - 访问 https://gist.github.com
   - 创建新的 Gist
   - 文件名：`privacy_policy.html`
   - 将 `privacy_policy.html` 的内容复制粘贴进去
   - 点击 "Create public gist"

2. **获取 URL**
   - 点击 "Raw" 按钮获取原始文件 URL
   - 使用此 URL 作为隐私政策网址

### 选项 3：使用其他免费托管服务

- **Netlify Drop**: https://app.netlify.com/drop
- **Vercel**: https://vercel.com
- **Firebase Hosting**: https://firebase.google.com/docs/hosting

### 选项 4：使用您自己的网站

如果您有自己的网站，只需将 `privacy_policy.html` 上传到您的网站根目录或特定目录即可。

## 在 Google Play Console 中添加隐私政策

1. 登录 Google Play Console
2. 选择您的应用
3. 进入 "政策" → "应用内容"
4. 找到 "隐私权政策" 部分
5. 点击 "开始" 或 "管理"
6. 输入您的隐私政策网址（例如：`https://username.github.io/decibel_meter/privacy_policy.html`）
7. 保存更改

## 验证

部署后，请确保：
- ✅ 隐私政策页面可以公开访问（无需登录）
- ✅ 页面在移动设备和桌面浏览器上都能正常显示
- ✅ URL 使用 HTTPS（Google Play 要求）
- ✅ 页面内容完整且格式正确

## 注意事项

- 隐私政策必须使用 HTTPS 协议
- URL 必须可公开访问，无需登录
- 建议定期审查和更新隐私政策内容
- 如果应用功能发生变化，请及时更新隐私政策

## 需要帮助？

如果您在部署过程中遇到问题，请参考：
- [GitHub Pages 文档](https://docs.github.com/en/pages)
- [Google Play 隐私政策要求](https://support.google.com/googleplay/android-developer/answer/10787469)