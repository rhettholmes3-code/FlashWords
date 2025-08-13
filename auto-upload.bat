@echo off

:: 检查是否有更改
git status --porcelain > nul
IF NOT ERRORLEVEL 1 (
    echo 没有更改，跳过提交步骤。
) ELSE (
    echo 正在添加更改到暂存区...
    git add .
    echo 正在提交更改...
    git commit -m "Auto commit"
)

:: 设置 GitHub 仓库地址 (替换为你的仓库地址)
SET REPO_URL=https://github.com/rhettholmes3-code/FlashWords.git

:: 设置远程仓库地址
git remote set-url origin %REPO_URL%

:: 推送到 GitHub
echo 正在将更改推送到 GitHub...
git push -u origin main

echo 上传完成！
pause
