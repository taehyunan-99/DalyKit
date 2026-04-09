# DalyKit Install Script
# 파일을 ~/.claude/에 복사하여 설치한다

$ErrorActionPreference = "Stop"

$HarnessRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$ClaudeRoot = Join-Path $env:USERPROFILE ".claude"

Write-Host "=== DalyKit Install ===" -ForegroundColor Cyan
Write-Host "Source: $HarnessRoot"
Write-Host "Target: $ClaudeRoot"
Write-Host ""

# 대상 디렉토리 생성
$dirs = @("skills", "shared", "hooks")
foreach ($dir in $dirs) {
    $targetDir = Join-Path $ClaudeRoot $dir
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Write-Host "  Created dir: $targetDir" -ForegroundColor Yellow
    }
}

# 스킬 설치 (디렉토리 복사)
$skills = @("init", "domain", "eda", "clean", "stat", "feature", "model", "help")
foreach ($skill in $skills) {
    $source = Join-Path $HarnessRoot "skills\$skill"
    $target = Join-Path $ClaudeRoot "skills\$skill"

    if (Test-Path $target) {
        Remove-Item $target -Recurse -Force
    }

    Copy-Item -Path $source -Destination $target -Recurse -Force
    Write-Host "  Skill installed: $skill" -ForegroundColor Green
}

# viz 공유 참조 문서 설치 (스킬이 아닌 공유 참조 문서)
$vizSource = Join-Path $HarnessRoot "shared\viz"
$vizTarget = Join-Path $ClaudeRoot "shared\viz"
if (Test-Path $vizTarget) { Remove-Item $vizTarget -Recurse -Force }
Copy-Item -Path $vizSource -Destination $vizTarget -Recurse -Force
Write-Host "  Shared docs installed: viz" -ForegroundColor Green

# 템플릿 설치
$templatesSource = Join-Path $HarnessRoot "templates"
$templatesTarget = Join-Path $ClaudeRoot "templates"
if (-not (Test-Path $templatesTarget)) { New-Item -ItemType Directory -Path $templatesTarget -Force | Out-Null }
Copy-Item -Path "$templatesSource\*" -Destination $templatesTarget -Recurse -Force
Write-Host "  Templates installed" -ForegroundColor Green

# guard_write 글로벌 설치 (guard_read는 프로젝트별 래퍼로 설치 — dalykit:init 참조)
$hooksSource = Join-Path $HarnessRoot "hooks"
$hooksTarget = Join-Path $ClaudeRoot "hooks"
Copy-Item -Path "$hooksSource\guard_write.py" -Destination "$hooksTarget\guard_write.py" -Force
Write-Host "  Hooks installed" -ForegroundColor Green

Write-Host ""
Write-Host "=== Install Complete ===" -ForegroundColor Cyan
Write-Host "Skills: $($skills.Count), Shared: viz, templates, hooks"
Write-Host ""
Write-Host "Usage: type 'dalykit:help' in Claude Code" -ForegroundColor Yellow
