# 🔧 修复 GitHub Pages 部署问题

## 问题说明

GitHub Actions 部署失败，错误信息显示：
- "Get Pages site failed"
- "Please verify that the repository has Pages enabled"

## ✅ 解决方案

### 方法 1：在 GitHub 网页上手动启用 Pages（推荐）

这是最可靠的方法：

1. **访问仓库设置**
   - 打开：https://github.com/Cute-Satsuma/decibel_meter/settings/pages

2. **启用 GitHub Pages**
   - 在 "Source" 部分，选择 **GitHub Actions**
   - 点击 **Save**

3. **重新运行 Workflow**
   - 访问：https://github.com/Cute-Satsuma/decibel_meter/actions
   - 找到失败的 workflow，点击 "Re-run all jobs"
   - 或者推送一个新的提交来触发 workflow

### 方法 2：使用分支部署（备选方案）

如果 GitHub Actions 仍然有问题，可以使用传统的分支部署：

1. **访问仓库设置**
   - 打开：https://github.com/Cute-Satsuma/decibel_meter/settings/pages

2. **配置 Pages**
   - Source: 选择 **Deploy from a branch**
   - Branch: 选择 **main**
   - Folder: 选择 **/ (root)**
   - 点击 **Save**

3. **访问隐私政策**
   - URL: https://cute-satsuma.github.io/decibel_meter/privacy_policy.html

## 📝 重要提示

- GitHub Pages 需要在仓库设置中**至少手动启用一次**
- 启用后，GitHub Actions workflow 才能正常工作
- 如果使用 GitHub Actions，Source 必须选择 "GitHub Actions"
- 如果使用分支部署，Source 必须选择 "Deploy from a branch"

## 🔍 验证步骤

启用 Pages 后，验证部署：

1. **检查 Pages 设置**
   - 访问：https://github.com/Cute-Satsuma/decibel_meter/settings/pages
   - 确认显示 "Your site is live at..."

2. **检查 Actions**
   - 访问：https://github.com/Cute-Satsuma/decibel_meter/actions
   - 确认 workflow 运行成功（绿色 ✓）

3. **访问隐私政策页面**
   - 打开：https://cute-satsuma.github.io/decibel_meter/privacy_policy.html
   - 确认页面可以正常显示

## 🚀 完成后的操作

部署成功后，在 Google Play Console 中添加隐私政策 URL：

```
https://cute-satsuma.github.io/decibel_meter/privacy_policy.html
```

---

**注意**：我已经更新了 workflow 文件，移除了可能不存在的参数。请在 GitHub 网页上启用 Pages 后，workflow 应该就能正常工作了。
