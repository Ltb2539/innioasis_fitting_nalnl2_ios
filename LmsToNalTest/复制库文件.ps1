# PowerShell 脚本 - 复制 NAL_NL2_SDK 库文件
# 使用方法: 在项目根目录运行此脚本

Write-Host "开始复制 NAL_NL2_SDK 库文件..." -ForegroundColor Green

$sourcePath = Join-Path $PSScriptRoot "..\DCTestUniPlugin\DCTestUniPlugin\NAL_NL2_SDK"
$destPath = Join-Path $PSScriptRoot "LmsToNalTest\NAL_NL2_SDK"

if (Test-Path $sourcePath) {
    Write-Host "源路径: $sourcePath" -ForegroundColor Yellow
    Write-Host "目标路径: $destPath" -ForegroundColor Yellow
    
    if (Test-Path $destPath) {
        Write-Host "目标路径已存在，是否覆盖? (Y/N)" -ForegroundColor Yellow
        $response = Read-Host
        if ($response -ne "Y" -and $response -ne "y") {
            Write-Host "操作已取消" -ForegroundColor Red
            exit
        }
        Remove-Item $destPath -Recurse -Force
    }
    
    Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Force
    Write-Host "✅ 库文件复制完成!" -ForegroundColor Green
    Write-Host "目标路径: $destPath" -ForegroundColor Cyan
} else {
    Write-Host "❌ 错误: 找不到源路径 $sourcePath" -ForegroundColor Red
    Write-Host "请确保 DCTestUniPlugin 项目存在且包含 NAL_NL2_SDK 文件夹" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "下一步: 在 Xcode 中打开项目并按照 '项目创建指南.md' 配置项目" -ForegroundColor Cyan

