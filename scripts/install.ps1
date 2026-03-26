# HarnessDA Install Script
# Creates junctions and hardlinks from HarnessDA to ~/.claude/

$ErrorActionPreference = "Stop"

$HarnessRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$ClaudeRoot = Join-Path $env:USERPROFILE ".claude"

Write-Host "=== HarnessDA Install ===" -ForegroundColor Cyan
Write-Host "Source: $HarnessRoot"
Write-Host "Target: $ClaudeRoot"
Write-Host ""

# Ensure target directories exist
$dirs = @("skills", "agents", "commands")
foreach ($dir in $dirs) {
    $targetDir = Join-Path $ClaudeRoot $dir
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Write-Host "  Created dir: $targetDir" -ForegroundColor Yellow
    }
}

# Install skills (Junction for directories)
$skills = @("eda", "data-clean", "stat-analysis", "da-viz")
foreach ($skill in $skills) {
    $source = Join-Path $HarnessRoot "skills\$skill"
    $target = Join-Path $ClaudeRoot "skills\$skill"

    if (Test-Path $target) {
        $item = Get-Item $target -Force
        if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            Remove-Item $target -Force
        } else {
            Write-Host "  WARN: $target already exists (not a junction). Skipped." -ForegroundColor Red
            continue
        }
    }

    New-Item -ItemType Junction -Path $target -Target $source | Out-Null
    Write-Host "  Skill installed: $skill" -ForegroundColor Green
}

# Install agents (HardLink for files)
$agents = @("data-profiler.md", "stat-analyst.md")
foreach ($agent in $agents) {
    $source = Join-Path $HarnessRoot "agents\$agent"
    $target = Join-Path $ClaudeRoot "agents\$agent"

    if (Test-Path $target) {
        $item = Get-Item $target -Force
        if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            Remove-Item $target -Force
        } else {
            Write-Host "  WARN: $target already exists. Skipped." -ForegroundColor Red
            continue
        }
    }

    New-Item -ItemType HardLink -Path $target -Target $source | Out-Null
    Write-Host "  Agent installed: $agent" -ForegroundColor Green
}

# Install commands (HardLink for files)
$commands = @("da.md")
foreach ($cmd in $commands) {
    $source = Join-Path $HarnessRoot "commands\$cmd"
    $target = Join-Path $ClaudeRoot "commands\$cmd"

    if (Test-Path $target) {
        $item = Get-Item $target -Force
        if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            Remove-Item $target -Force
        } else {
            Write-Host "  WARN: $target already exists. Skipped." -ForegroundColor Red
            continue
        }
    }

    New-Item -ItemType HardLink -Path $target -Target $source | Out-Null
    Write-Host "  Command installed: $cmd" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Install Complete ===" -ForegroundColor Cyan
Write-Host "Skills: $($skills.Count), Agents: $($agents.Count), Commands: $($commands.Count)"
Write-Host ""
Write-Host "Usage: type '/da' in Claude Code" -ForegroundColor Yellow
