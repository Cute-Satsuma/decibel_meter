# GitHub SSH Key 设置指南

## ✅ SSH Key 已生成

您的 GitHub SSH key 已成功生成！

### 📋 公钥内容

请复制以下完整的公钥内容（从 `ssh-ed25519` 开始到结尾）：

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJU+6+slHSyPLhZssQTJi84W4qg6Iu4rp4IQZSuVywaz github
```

## 🔑 将 SSH Key 添加到 GitHub

### 步骤 1：访问 GitHub SSH 设置页面

1. 登录您的 GitHub 账号
2. 点击右上角头像 → **Settings**（设置）
3. 在左侧菜单中找到并点击 **SSH and GPG keys**
4. 或者直接访问：https://github.com/settings/keys

### 步骤 2：添加新的 SSH Key

1. 点击绿色的 **New SSH key**（新建 SSH 密钥）按钮
2. 填写信息：
   - **Title**（标题）：`CS Decibel Meter - Mac`（或您喜欢的名称）
   - **Key type**（密钥类型）：选择 **Authentication Key**
   - **Key**（密钥）：粘贴上面复制的完整公钥内容
3. 点击 **Add SSH key**（添加 SSH 密钥）
4. 如果需要，输入您的 GitHub 密码确认

### 步骤 3：验证 SSH 连接

在终端中运行以下命令测试连接：

```bash
ssh -T git@github.com
```

如果成功，您会看到类似以下的消息：
```
Hi YOUR_USERNAME! You've successfully authenticated, but GitHub does not provide shell access.
```

## 🚀 使用 SSH URL 推送代码

配置完成后，您可以使用 SSH URL 来推送代码：

```bash
cd /Users/wilsony/AndroidStudioProjects/decibel_meter

# 如果之前添加了 HTTPS 远程仓库，可以改为 SSH
git remote set-url origin git@github.com:YOUR_USERNAME/decibel_meter.git

# 或者直接添加 SSH 远程仓库
git remote add origin git@github.com:YOUR_USERNAME/decibel_meter.git

# 推送代码
git push -u origin main
```

## 📝 SSH Key 文件位置

- **私钥**：`~/.ssh/id_ed25519_github`（请妥善保管，不要分享）
- **公钥**：`~/.ssh/id_ed25519_github.pub`（已添加到 GitHub）
- **SSH 配置**：`~/.ssh/config`（已配置自动使用此密钥）

## 🔒 安全提示

- ✅ 私钥文件权限已设置为 600（仅所有者可读写）
- ✅ SSH config 已配置，GitHub 会自动使用此密钥
- ⚠️ **不要**将私钥分享给任何人或提交到代码仓库
- ⚠️ 如果私钥泄露，请立即在 GitHub 上删除对应的公钥并重新生成

## 🛠️ 故障排除

### 问题 1：SSH 连接测试失败

**解决方案**：
```bash
# 检查 SSH agent 是否运行
eval "$(ssh-agent -s)"

# 添加密钥到 SSH agent
ssh-add ~/.ssh/id_ed25519_github

# 再次测试
ssh -T git@github.com
```

### 问题 2：权限被拒绝（Permission denied）

**可能原因**：
- 公钥未正确添加到 GitHub
- SSH agent 未加载密钥

**解决方案**：
```bash
# 检查密钥是否已加载
ssh-add -l

# 如果没有显示您的密钥，手动添加
ssh-add ~/.ssh/id_ed25519_github
```

### 问题 3：多个 SSH Key 冲突

如果您的系统有多个 SSH key，SSH config 文件已配置为 GitHub 专门使用 `id_ed25519_github`。如果需要为其他服务使用不同的 key，可以在 `~/.ssh/config` 中添加更多配置。

## ✅ 检查清单

完成以下步骤后，您就可以使用 SSH 推送代码了：

- [ ] SSH key 已生成
- [ ] 公钥已添加到 GitHub
- [ ] SSH 连接测试成功
- [ ] 远程仓库 URL 已设置为 SSH 格式
- [ ] 可以成功推送代码

---

**提示**：使用 SSH key 后，您将不再需要每次推送时输入 GitHub 用户名和密码，更加方便快捷！
