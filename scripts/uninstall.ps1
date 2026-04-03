# HarnessDA Uninstall Script
# Removes installed files. Original files are preserved.

$ErrorActionPreference = "Stop"

$ClaudeRoot = Join-Path $env:USERPROFILE ".claude"

Write-Host "=== HarnessDA Uninstall ===" -ForegroundColor Cyan
Write-Host ""

$removed = 0

# 스킬 제거
$skills = @("init", "eda", "clean", "stat", "report", "help")
foreach ($skill in $skills) {
    $target = Join-Path $ClaudeRoot "skills\$skill"
    if (Test-Path $target) {
        Remove-Item $target -Recurse -Force
        Write-Host "  Skill removed: $skill" -ForegroundColor Yellow
        $removed++
    }
}

# viz 공유 참조 문서 제거
$vizTarget = Join-Path $ClaudeRoot "skills\viz"
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

# 에이전트 제거
$agents = @("data-profiler.md")
foreach ($agent in $agents) {
    $target = Join-Path $ClaudeRoot "agents\$agent"
    if (Test-Path $target) {
        Remove-Item $target -Force
        Write-Host "  Agent removed: $agent" -ForegroundColor Yellow
        $removed++
    }
}

Write-Host ""
if ($removed -gt 0) {
    Write-Host "=== Uninstall Complete: $removed items removed ===" -ForegroundColor Cyan
} else {
    Write-Host "=== Nothing to remove ===" -ForegroundColor Yellow
}
