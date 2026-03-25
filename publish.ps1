# publish.ps1 — Obsidian → Quartz 자동 배포 스크립트
# 사용법: cd C:\Dev\quartz && .\publish.ps1 [-Message "커밋 메시지"]
param(
    [string]$Message = "Update content"
)

$ObsidianRoot = "C:\Dev\Obsidian"
$QuartzContent = "C:\Dev\quartz\content"

# ──────────────────────────────────────────
# 1. Home.md 자동 생성
# ──────────────────────────────────────────

function Get-NoteLinks {
    param([string]$FolderPath, [string]$QuartzPrefix, [int]$Limit = 5)
    if (-not (Test-Path $FolderPath)) { return @() }
    $files = Get-ChildItem $FolderPath -Filter "*.md" -File |
        Where-Object { $_.Name -ne "_index.md" } |
        Sort-Object Name -Descending |
        Select-Object -First $Limit
    return $files | ForEach-Object {
        $title = $_.BaseName -replace '^\(\d{6}\)', '' -replace '^\s+', ''
        $date  = if ($_.Name -match '^\((\d{2})(\d{2})(\d{2})\)') { "20$($Matches[1])-$($Matches[2])-$($Matches[3])" } else { "" }
        $link  = "$QuartzPrefix/$($_.BaseName)"
        if ($date) { "- [[$link|$date $title]]" } else { "- [[$link|$title]]" }
    }
}

$dailyLinks  = Get-NoteLinks "$ObsidianRoot\Daily"                   "Daily"                   -Limit 5
$ideaLinks   = Get-NoteLinks "$ObsidianRoot\4. Zettelkasten"         "4. Zettelkasten"         -Limit 5
$newsLinks   = Get-NoteLinks "$ObsidianRoot\2. Resources\AI-News"    "2. Resources/AI-News"    -Limit 5
$paperLinks  = Get-NoteLinks "$ObsidianRoot\2. Resources\Papers"     "2. Resources/Papers"     -Limit 5

$dailySection  = if ($dailyLinks)  { $dailyLinks  -join "`n" } else { "_(없음)_" }
$ideaSection   = if ($ideaLinks)   { $ideaLinks   -join "`n" } else { "_(없음)_" }
$newsSection   = if ($newsLinks)   { $newsLinks   -join "`n" } else { "_(없음)_" }
$paperSection  = if ($paperLinks)  { $paperLinks  -join "`n" } else { "_(없음)_" }

$homeContent = @"
---
type: hub
tags:
  - hub
publish: true
---
# Home

## 최근 학습 일지

$dailySection

## 최근 아이디어

$ideaSection

## 최근 AI 뉴스

$newsSection

## 최근 논문

$paperSection
"@

Set-Content -Path "$QuartzContent\00_Home.md" -Value $homeContent -Encoding UTF8
Write-Host "Home.md 생성 완료" -ForegroundColor Green

# ──────────────────────────────────────────
# 2. 배포 대상 노트 복사
# ──────────────────────────────────────────

$publishFolders = @(
    @{ Src = "Daily";                    Dst = "Daily" },
    @{ Src = "2. Resources\LLM\Agent";   Dst = "2. Resources\LLM\Agent" },
    @{ Src = "2. Resources\LLM\RAG";     Dst = "2. Resources\LLM\RAG" },
    @{ Src = "2. Resources\AI-News";     Dst = "2. Resources\AI-News" },
    @{ Src = "2. Resources\AI-Hardware"; Dst = "2. Resources\AI-Hardware" },
    @{ Src = "2. Resources\Articles";    Dst = "2. Resources\Articles" },
    @{ Src = "2. Resources\Papers";      Dst = "2. Resources\Papers" },
    @{ Src = "4. Zettelkasten";          Dst = "4. Zettelkasten" }
)

foreach ($pair in $publishFolders) {
    $src = "$ObsidianRoot\$($pair.Src)"
    $dst = "$QuartzContent\$($pair.Dst)"
    if (Test-Path $src) {
        New-Item -ItemType Directory -Force $dst | Out-Null
        Copy-Item "$src\*.md" $dst -Force -ErrorAction SilentlyContinue
        Write-Host "복사: $($pair.Src)" -ForegroundColor Cyan
    }
}

# SVG 첨부 파일 복사
$svgSrc = "$ObsidianRoot\6. Attachments"
$svgDst = "$QuartzContent\6. Attachments"
if (Test-Path $svgSrc) {
    New-Item -ItemType Directory -Force $svgDst | Out-Null
    Copy-Item "$svgSrc\*" $svgDst -Force -ErrorAction SilentlyContinue
    Write-Host "복사: 6. Attachments" -ForegroundColor Cyan
}

# ──────────────────────────────────────────
# 3. Git push
# ──────────────────────────────────────────

Set-Location "C:\Dev\quartz"
git add .
$status = git status --porcelain
if ($status) {
    git commit -m $Message
    git push origin main
    Write-Host "GitHub push 완료" -ForegroundColor Green
} else {
    Write-Host "변경 사항 없음 — push 생략" -ForegroundColor Yellow
}
