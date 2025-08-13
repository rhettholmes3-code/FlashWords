#!/bin/bash

# 确保脚本被正确运行
if [ -z "$(git status --porcelain)" ]; then
  echo "没有更改，跳过提交步骤。"
else
  echo "正在添加更改到暂存区..."
  git add .
  echo "正在提交更改..."
  git commit -m "Auto commit"
fi

# 设置 GitHub 仓库地址 (替换为你的仓库地址)
REPO_URL="https://github.com/rhettholmes3-code/FlashWords.git"

# 确保远程仓库已设置
git remote set-url origin $REPO_URL

# 推送到 GitHub
echo "正在将更改推送到 GitHub..."
git push -u origin main

echo "上传完成！"
