#!/bin/bash

# 隐私政策 GitHub Pages 部署脚本
# 使用方法：./deploy_privacy_policy.sh

echo "=========================================="
echo "CS Decibel Meter - 隐私政策部署助手"
echo "=========================================="
echo ""

# 检查是否已配置远程仓库
if git remote -v | grep -q "origin"; then
    echo "✓ 已检测到远程仓库"
    REMOTE_URL=$(git remote get-url origin)
    echo "  远程仓库: $REMOTE_URL"
    echo ""
    
    # 提取 GitHub 用户名和仓库名
    if [[ $REMOTE_URL =~ github.com[:/]([^/]+)/([^/]+) ]]; then
        GITHUB_USER="${BASH_REMATCH[1]}"
        REPO_NAME="${BASH_REMATCH[2]%.git}"
        REPO_NAME="${REPO_NAME%.git}"
        
        echo "检测到的信息："
        echo "  GitHub 用户名: $GITHUB_USER"
        echo "  仓库名: $REPO_NAME"
        echo ""
        echo "您的隐私政策 URL 将是："
        echo "  https://$GITHUB_USER.github.io/$REPO_NAME/privacy_policy.html"
        echo ""
        echo "=========================================="
        echo "下一步操作："
        echo "=========================================="
        echo "1. 推送代码到 GitHub："
        echo "   git push -u origin main"
        echo ""
        echo "2. 在 GitHub 上启用 Pages："
        echo "   - 访问: https://github.com/$GITHUB_USER/$REPO_NAME/settings/pages"
        echo "   - Source: Deploy from a branch"
        echo "   - Branch: main, / (root)"
        echo "   - 点击 Save"
        echo ""
        echo "3. 等待几分钟后访问您的隐私政策："
        echo "   https://$GITHUB_USER.github.io/$REPO_NAME/privacy_policy.html"
        echo ""
    else
        echo "⚠ 无法从远程 URL 提取 GitHub 信息"
        echo "请手动在 GitHub 上启用 Pages"
    fi
else
    echo "⚠ 未检测到远程仓库"
    echo ""
    echo "请先添加 GitHub 远程仓库："
    echo "  git remote add origin https://github.com/您的用户名/仓库名.git"
    echo ""
    echo "然后推送代码："
    echo "  git push -u origin main"
    echo ""
    echo "最后在 GitHub 仓库设置中启用 Pages"
fi

echo ""
echo "=========================================="
echo "快速部署步骤（如果还没有 GitHub 仓库）："
echo "=========================================="
echo "1. 在 GitHub 创建新仓库（例如：decibel_meter）"
echo "2. 添加远程仓库："
echo "   git remote add origin https://github.com/您的用户名/仓库名.git"
echo "3. 推送代码："
echo "   git push -u origin main"
echo "4. 在 GitHub 仓库设置中启用 Pages"
echo "5. 使用生成的 URL 在 Google Play Console 中添加隐私政策"
echo ""
