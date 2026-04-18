# DalyKit local development uninstall script
# ~/.claude/plugins/dev/dalykit 개발용 번들만 제거한다.

$ErrorActionPreference = "Stop"

$TargetRoot = Join-Path $env:USERPROFILE ".claude\plugins\dev\dalykit"

Write-Host "=== DalyKit Local Dev Uninstall ===" -ForegroundColor Cyan
Write-Host "Target: $TargetRoot"
Write-Host ""

if (Test-Path $TargetRoot) {
    Remove-Item $TargetRoot -Recurse -Force
    Write-Host "Removed: $TargetRoot" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "=== Uninstall Complete ===" -ForegroundColor Cyan
} else {
    Write-Host "Nothing to remove." -ForegroundColor Yellow
}
