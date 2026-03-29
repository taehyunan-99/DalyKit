# HarnessDA Uninstall Script
# Removes junctions and hardlinks. Original files are preserved.

$ErrorActionPreference = "Stop"

$ClaudeRoot = Join-Path $env:USERPROFILE ".claude"

Write-Host "=== HarnessDA Uninstall ===" -ForegroundColor Cyan
Write-Host ""

$removed = 0

# Remove skills (Junctions)
$skills = @("eda", "data-clean", "stat-analysis", "viz", "report", "help", "tracker")
foreach ($skill in $skills) {
    $target = Join-Path $ClaudeRoot "skills\$skill"
    if (Test-Path $target) {
        $item = Get-Item $target -Force
        if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            Remove-Item $target -Force
            Write-Host "  Skill removed: $skill" -ForegroundColor Yellow
            $removed++
        } else {
            Write-Host "  Skipped: $skill (not a junction)" -ForegroundColor Red
        }
    }
}

# Remove agents
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
