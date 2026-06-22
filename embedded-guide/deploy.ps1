# GitHub Pages 部署脚本
# 使用前请先完成以下步骤：
# 1. 在 GitHub 创建仓库（仓库名：embedded-guide）
# 2. 配置 Git（见下方说明）

Write-Host "=== GitHub Pages 部署向导 ===" -ForegroundColor Cyan
Write-Host ""

# 检查Git配置
$gitUser = git config --global user.name
$gitEmail = git config --global user.email

if ([string]::IsNullOrEmpty($gitUser) -or [string]::IsNullOrEmpty($gitEmail)) {
    Write-Host "⚠ Git 尚未配置，请先运行以下命令：" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "git config --global user.name `"你的GitHub用户名`"" -ForegroundColor Green
    Write-Host "git config --global user.email `"你的GitHub邮箱`"" -ForegroundColor Green
    Write-Host ""
    Write-Host "配置完成后重新运行此脚本。"
    pause
    exit
}

Write-Host "✓ Git 配置正常" -ForegroundColor Green
Write-Host "  用户名: $gitUser"
Write-Host "  邮箱: $gitEmail"
Write-Host ""

# 获取GitHub用户名
Write-Host "请输入你的 GitHub 用户名（就是上面配置的用户名）：" -ForegroundColor Cyan
$githubUser = Read-Host

if ([string]::IsNullOrEmpty($githubUser)) {
    Write-Host "✗ 用户名不能为空" -ForegroundColor Red
    pause
    exit
}

Write-Host ""
Write-Host "=== 开始部署 ===" -ForegroundColor Cyan
Write-Host ""

# 初始化Git仓库
if (Test-Path ".git") {
    Write-Host "检测到已有Git仓库，跳过初始化"
} else {
    Write-Host "1. 初始化Git仓库..."
    git init
    git branch -M main
}

# 添加文件
Write-Host "2. 添加文件到Git..."
git add .

# 提交
Write-Host "3. 创建提交..."
git commit -m "Initial commit: 嵌入式开发学习路线指南"

# 添加远程仓库
$repoUrl = "https://github.com/$githubUser/embedded-guide.git"
Write-Host "4. 连接到远程仓库..."
Write-Host "   仓库地址: $repoUrl"

$remoteExists = git remote get-url origin 2>$null
if ($remoteExists) {
    git remote set-url origin $repoUrl
} else {
    git remote add origin $repoUrl
}

# 推送
Write-Host ""
Write-Host "5. 推送到GitHub..."
Write-Host "   (首次推送需要输入GitHub用户名和密码/Token)" -ForegroundColor Yellow
Write-Host ""

git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=== 部署成功！ ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "下一步：在GitHub启用Pages" -ForegroundColor Cyan
    Write-Host "1. 访问 https://github.com/$githubUser/embedded-guide" -ForegroundColor White
    Write-Host "2. 点击 Settings（设置）" -ForegroundColor White
    Write-Host "3. 左侧菜单找到 Pages" -ForegroundColor White
    Write-Host "4. Source 选择 'Deploy from a branch'" -ForegroundColor White
    Write-Host "5. Branch 选择 'main'，文件夹选 '/ (root)'" -ForegroundColor White
    Write-Host "6. 点击 Save" -ForegroundColor White
    Write-Host ""
    Write-Host "等待约1-5分钟后，访问：" -ForegroundColor Cyan
    Write-Host "https://$githubUser.github.io/embedded-guide/" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "=== 推送失败 ===" -ForegroundColor Red
    Write-Host ""
    Write-Host "可能的原因：" -ForegroundColor Yellow
    Write-Host "1. 还没在GitHub创建 embedded-guide 仓库"
    Write-Host "   → 访问 https://github.com/new 创建"
    Write-Host "   → 仓库名必须是: embedded-guide"
    Write-Host "   → 不要勾选任何初始化选项（README/gitignore/license）"
    Write-Host ""
    Write-Host "2. 认证失败"
    Write-Host "   → GitHub已不支持密码登录，需要使用Personal Access Token"
    Write-Host "   → 生成Token: https://github.com/settings/tokens"
    Write-Host "   → 权限至少勾选: repo (全部)"
    Write-Host "   → 用Token代替密码输入"
    Write-Host ""
}

Write-Host ""
pause
