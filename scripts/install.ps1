# HarnessDA Install Script
# 파일을 ~/.claude/에 복사하여 설치한다

$ErrorActionPreference = "Stop"

$HarnessRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$ClaudeRoot = Join-Path $env:USERPROFILE ".claude"

Write-Host "=== HarnessDA Install ===" -ForegroundColor Cyan
Write-Host "Source: $HarnessRoot"
Write-Host "Target: $ClaudeRoot"
Write-Host ""

# 대상 디렉토리 생성
$dirs = @("skills", "agents")
foreach ($dir in $dirs) {
    $targetDir = Join-Path $ClaudeRoot $dir
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Write-Host "  Created dir: $targetDir" -ForegroundColor Yellow
    }
}

# 스킬 설치 (디렉토리 복사)
$skills = @("eda", "data-clean", "stat-analysis", "viz", "report", "help", "tracker")
foreach ($skill in $skills) {
    $source = Join-Path $HarnessRoot "skills\$skill"
    $target = Join-Path $ClaudeRoot "skills\$skill"

    if (Test-Path $target) {
        Remove-Item $target -Recurse -Force
    }

    Copy-Item -Path $source -Destination $target -Recurse -Force
    Write-Host "  Skill installed: $skill" -ForegroundColor Green
}

# 에이전트 설치 (파일 복사)
$agents = @("data-profiler.md")
foreach ($agent in $agents) {
    $source = Join-Path $HarnessRoot "agents\$agent"
    $target = Join-Path $ClaudeRoot "agents\$agent"

    if (Test-Path $target) { Remove-Item $target -Force }
    Copy-Item -Path $source -Destination $target -Force
    Write-Host "  Agent installed: $agent" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Install Complete ===" -ForegroundColor Cyan
Write-Host "Skills: $($skills.Count), Agents: $($agents.Count)"
Write-Host ""
Write-Host "Usage: type 'harnessda:help' in Claude Code" -ForegroundColor Yellow
