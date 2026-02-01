# GitHub Pages 部署详细步骤

## 📋 准备工作

✅ 隐私政策文件已创建：`privacy_policy.html`  
✅ Git 仓库已初始化  
✅ 文件已提交到本地仓库

## 🚀 部署步骤

### 步骤 1：在 GitHub 上创建仓库

1. 访问 https://github.com/new
2. 填写仓库信息：
   - **Repository name**: `decibel_meter`（或您喜欢的名称）
   - **Description**: CS Decibel Meter - Privacy Policy
   - **Visibility**: Public（GitHub Pages 免费版需要公开仓库）
   - **不要**勾选 "Initialize this repository with a README"
3. 点击 "Create repository"

### 步骤 2：添加远程仓库并推送代码

在终端中执行以下命令（替换 `YOUR_USERNAME` 为您的 GitHub 用户名）：

```bash
cd /Users/wilsony/AndroidStudioProjects/decibel_meter

# 添加远程仓库
git remote add origin https://github.com/YOUR_USERNAME/decibel_meter.git

# 推送代码到 GitHub
git branch -M main
git push -u origin main
```

**注意**：如果这是您第一次推送，GitHub 可能会要求您输入用户名和密码（或使用 Personal Access Token）。

### 步骤 3：启用 GitHub Pages

1. 访问您的 GitHub 仓库页面：`https://github.com/YOUR_USERNAME/decibel_meter`
2. 点击右上角的 **Settings**（设置）
3. 在左侧菜单中找到并点击 **Pages**
4. 在 "Source" 部分：
   - 选择 **Deploy from a branch**
   - Branch: 选择 **main**
   - Folder: 选择 **/ (root)**
5. 点击 **Save**（保存）

### 步骤 4：等待部署完成

- GitHub Pages 通常需要 1-2 分钟来部署
- 部署完成后，您会看到绿色的成功提示
- 您的隐私政策 URL 将是：
  ```
  https://YOUR_USERNAME.github.io/decibel_meter/privacy_policy.html
  ```

### 步骤 5：验证隐私政策页面

1. 访问您的隐私政策 URL
2. 确认页面可以正常显示
3. 检查中英文内容是否完整

### 步骤 6：在 Google Play Console 中添加

1. 登录 [Google Play Console](https://play.google.com/console)
2. 选择您的应用（CS Decibel Meter）
3. 进入 **政策** → **应用内容**
4. 找到 **隐私权政策** 部分
5. 点击 **开始** 或 **管理**
6. 在 "隐私权政策网址" 字段中输入：
   ```
   https://YOUR_USERNAME.github.io/decibel_meter/privacy_policy.html
   ```
7. 点击 **保存**

## 🔧 故障排除

### 问题 1：推送时要求身份验证

**解决方案**：
- 使用 Personal Access Token 代替密码
- 创建 Token：GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
- 权限选择：`repo`（完整仓库访问权限）

### 问题 2：Pages 显示 404

**可能原因**：
- 部署尚未完成（等待几分钟）
- 分支名称不是 `main`（检查并重命名分支）
- 文件路径不正确

**解决方案**：
```bash
# 检查当前分支
git branch

# 如果不是 main，重命名分支
git branch -M main
git push -u origin main
```

### 问题 3：HTTPS 证书问题

GitHub Pages 自动提供 HTTPS，无需额外配置。如果浏览器显示不安全，请检查：
- URL 是否正确（应该是 `https://` 开头）
- 是否访问了正确的域名（`.github.io`）

## 📝 更新隐私政策

如果需要更新隐私政策内容：

1. 编辑 `privacy_policy.html` 文件
2. 提交更改：
   ```bash
   git add privacy_policy.html
   git commit -m "Update privacy policy"
   git push
   ```
3. GitHub Pages 会自动更新（通常需要几分钟）

## ✅ 检查清单

部署完成后，请确认：

- [ ] 隐私政策页面可以公开访问（无需登录）
- [ ] URL 使用 HTTPS 协议
- [ ] 页面在移动设备和桌面浏览器上都能正常显示
- [ ] 中英文内容完整且格式正确
- [ ] 已在 Google Play Console 中添加隐私政策 URL
- [ ] Google Play Console 显示隐私政策状态为"已添加"

## 🎯 快速命令参考

```bash
# 检查远程仓库
git remote -v

# 查看提交历史
git log --oneline

# 检查当前分支
git branch

# 推送更新
git push
```

## 📞 需要帮助？

如果遇到问题，可以：
1. 查看 [GitHub Pages 官方文档](https://docs.github.com/en/pages)
2. 检查 GitHub 仓库的 Actions 标签页查看部署状态
3. 查看 [Google Play 隐私政策要求](https://support.google.com/googleplay/android-developer/answer/10787469)

---

**提示**：部署完成后，建议将隐私政策 URL 保存在安全的地方，以便将来更新时使用。