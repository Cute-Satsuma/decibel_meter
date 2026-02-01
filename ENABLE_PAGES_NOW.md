# 🚀 立即启用 GitHub Pages - 详细步骤

## ⚠️ 重要：必须先完成这一步！

GitHub Pages **必须在仓库设置中手动启用一次**，之后 GitHub Actions 才能正常工作。

## 📋 方法 1：使用 GitHub Actions（推荐）

### 步骤 1：启用 GitHub Pages

1. **打开仓库设置页面**
   ```
   https://github.com/Cute-Satsuma/decibel_meter/settings/pages
   ```

2. **配置 Pages 设置**
   - 在 "Source" 部分，选择 **GitHub Actions**
   - **不要**选择 "Deploy from a branch"
   - 点击 **Save** 按钮

3. **等待几秒钟**
   - 页面会刷新并显示 "Your site is live at..."
   - 如果看到错误，继续下一步

### 步骤 2：触发部署

启用 Pages 后，有两种方式触发部署：

**方式 A：手动触发（推荐）**
1. 访问 Actions 页面：
   ```
   https://github.com/Cute-Satsuma/decibel_meter/actions
   ```
2. 在左侧找到 "Deploy Privacy Policy to GitHub Pages" workflow
3. 点击 "Run workflow" 按钮
4. 选择 "main" 分支
5. 点击绿色的 "Run workflow" 按钮
6. 等待部署完成（通常 1-2 分钟）

**方式 B：自动触发**
- 我已经推送了新的代码，workflow 应该会自动运行
- 访问 Actions 页面查看状态

### 步骤 3：验证部署

部署成功后，访问：
```
https://cute-satsuma.github.io/decibel_meter/privacy_policy.html
```

## 📋 方法 2：使用分支部署（如果方法 1 失败）

如果 GitHub Actions 仍然有问题，可以使用传统的分支部署：

### 步骤 1：启用 Pages

1. **打开仓库设置页面**
   ```
   https://github.com/Cute-Satsuma/decibel_meter/settings/pages
   ```

2. **配置 Pages 设置**
   - Source: 选择 **Deploy from a branch**
   - Branch: 选择 **main**
   - Folder: 选择 **/docs**
   - 点击 **Save**

3. **等待部署**
   - 通常需要 1-2 分钟
   - 页面会显示 "Your site is live at..."

### 步骤 2：验证

访问隐私政策：
```
https://cute-satsuma.github.io/decibel_meter/privacy_policy.html
```

## 🔍 检查部署状态

### 检查 Pages 设置
1. 访问：https://github.com/Cute-Satsuma/decibel_meter/settings/pages
2. 应该看到 "Your site is live at https://cute-satsuma.github.io/decibel_meter/"

### 检查 Actions
1. 访问：https://github.com/Cute-Satsuma/decibel_meter/actions
2. 找到最新的 workflow 运行
3. 如果显示绿色 ✓，说明部署成功
4. 如果显示红色 ✗，点击查看错误信息

### 检查页面
1. 访问：https://cute-satsuma.github.io/decibel_meter/privacy_policy.html
2. 应该能看到隐私政策页面（中英文内容）

## 🛠️ 常见问题

### 问题 1：Pages 设置页面显示 "Not published"

**原因**：Pages 还没有启用或配置不正确

**解决方案**：
1. 确保选择了正确的 Source（GitHub Actions 或 Deploy from a branch）
2. 如果选择分支部署，确保选择了 `/docs` 文件夹
3. 点击 Save 后等待几分钟

### 问题 2：Workflow 失败，显示 "Get Pages site failed"

**原因**：Pages 还没有在设置中启用

**解决方案**：
1. **必须先**在设置页面启用 Pages（见上面的步骤 1）
2. 然后重新运行 workflow

### 问题 3：页面显示 404

**可能原因**：
- 部署还没有完成（等待几分钟）
- URL 不正确
- Pages 没有正确启用

**解决方案**：
1. 检查 Pages 设置是否正确
2. 等待 5-10 分钟让部署完成
3. 确认 URL 格式：`https://cute-satsuma.github.io/decibel_meter/privacy_policy.html`

## ✅ 成功标志

部署成功后，您应该能够：

- ✅ 在 Pages 设置页面看到 "Your site is live at..."
- ✅ 在 Actions 页面看到成功的 workflow 运行（绿色 ✓）
- ✅ 访问 https://cute-satsuma.github.io/decibel_meter/privacy_policy.html 能看到页面内容

## 📱 在 Google Play Console 中使用

部署成功后，在 Google Play Console 中添加隐私政策 URL：

```
https://cute-satsuma.github.io/decibel_meter/privacy_policy.html
```

---

**重要提示**：无论使用哪种方法，**第一步都是在 GitHub 仓库设置页面启用 Pages**。这是必须的步骤！
