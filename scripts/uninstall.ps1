# DalyKit Uninstall Script
# Removes installed files. Original files are preserved.

$ErrorActionPreference = "Stop"

$ClaudeRoot = Join-Path $env:USERPROFILE ".claude"

Write-Host "=== DalyKit Uninstall ===" -ForegroundColor Cyan
Write-Host ""

$removed = 0

# 스킬 제거
$skills = @("init", "domain", "eda", "clean", "stat", "feature", "model", "help")
foreach ($skill in $skills) {
    $target = Join-Path $ClaudeRoot "skills\$skill"
    if (Test-Path $target) {
        Remove-Item $target -Recurse -Force
        Write-Host "  Skill removed: $skill" -ForegroundColor Yellow
        $removed++
    }
}

# viz 공유 참조 문서 제거
$vizTarget = Join-Path $ClaudeRoot "shared\viz"
if (Test-Path $vizTarget) {
    Remove-Item $vizTarget -Recurse -Force
    Write-Host "  Shared docs removed: viz" -ForegroundColor Yellow
    $removed++
}

# 템플릿 제거
$templatesTarget = Join-Path $ClaudeRoot "templates"
if (Test-Path $templatesTarget) {
    Remove-Item $templatesTarget -Recurse -Force
    Write-Host "  Templates removed" -ForegroundColor Yellow
    $removed++
}

# hook 스크립트 제거
$hooks = @("guard_write.py", "guard_read.py")
foreach ($hook in $hooks) {
    $target = Join-Path $ClaudeRoot "hooks\$hook"
    if (Test-Path $target) {
        Remove-Item $target -Force
        Write-Host "  Hook removed: $hook" -ForegroundColor Yellow
        $removed++
    }
}

Write-Host ""
if ($removed -gt 0) {
    Write-Host "=== Uninstall Complete: $removed items removed ===" -ForegroundColor Cyan
} else {
    Write-Host "=== Nothing to remove ===" -ForegroundColor Yellow
}
