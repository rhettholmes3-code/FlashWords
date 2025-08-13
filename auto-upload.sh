#!/bin/bash

# 设置错误时退出
set -e

echo "🚀 开始自动上传到 GitHub..."

# 检查是否在Git仓库中
if [ ! -d ".git" ]; then
    echo "❌ 错误：当前目录不是Git仓库"
    echo "请先运行: git init"
    exit 1
fi

# 检查是否有远程仓库
if ! git remote get-url origin > /dev/null 2>&1; then
    echo "❌ 错误：未设置远程仓库"
    echo "请先运行: git remote add origin <your-repo-url>"
    exit 1
fi

# 检查是否有更改
if [ -z "$(git status --porcelain)" ]; then
    echo "✅ 没有更改，跳过提交步骤。"
else
    echo "📝 正在添加更改到暂存区..."
    git add .
    
    echo "💾 正在提交更改..."
    git commit -m "Auto commit: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "✅ 提交完成"
fi

# 设置 GitHub 仓库地址 (替换为你的仓库地址)
REPO_URL="https://github.com/rhettholmes3-code/FlashWords.git"

# 确保远程仓库已设置
echo "🔗 设置远程仓库..."
git remote set-url origin $REPO_URL

# 推送到 GitHub
echo "📤 正在将更改推送到 GitHub..."
if git push -u origin main; then
    echo "✅ 上传完成！"
    echo "🌐 仓库地址: $REPO_URL"
else
    echo "❌ 推送失败，请检查网络连接和权限"
    exit 1
fi
