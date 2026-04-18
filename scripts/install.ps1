# DalyKit local development sync script
# Marketplace 사용자는 이 스크립트가 아니라 /plugin marketplace install 흐름을 사용한다.
# 이 스크립트는 로컬 개발용으로 플러그인 번들을 ~/.claude/plugins/dev/dalykit 에 동기화한다.

$ErrorActionPreference = "Stop"

$PluginRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$TargetRoot = Join-Path $env:USERPROFILE ".claude\plugins\dev\dalykit"

Write-Host "=== DalyKit Local Dev Sync ===" -ForegroundColor Cyan
Write-Host "Source: $PluginRoot"
Write-Host "Target: $TargetRoot"
Write-Host ""

if (Test-Path $TargetRoot) {
    Remove-Item $TargetRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $TargetRoot -Force | Out-Null

$paths = @(".claude-plugin", "shared", "skills", "templates", "README.md", "README.en.md")
foreach ($path in $paths) {
    $source = Join-Path $PluginRoot $path
    $target = Join-Path $TargetRoot $path
    if (Test-Path $source) {
        Copy-Item -Path $source -Destination $target -Recurse -Force
        Write-Host "  Synced: $path" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "=== Sync Complete ===" -ForegroundColor Cyan
Write-Host "Local plugin bundle: $TargetRoot"
Write-Host ""
Write-Host "Run for local testing:" -ForegroundColor Yellow
Write-Host "  claude --plugin-dir `"$TargetRoot`"" -ForegroundColor Yellow
