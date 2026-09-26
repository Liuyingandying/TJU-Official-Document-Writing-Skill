# Install script for TJU-Official-Document-Writing-Skill (idempotent).
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install.ps1
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install.ps1 -SkillsRoot "D:\custom\skills"
#
# What it does:
#   1. Ensures the skills root exists (default: $HOME\.agents\skills)
#   2. Ensures the upstream dependency official-document-writing is present (clones once if missing)
#   3. Installs THIS skill (SKILL.md + references + tju-extension) into official-document-writing-tju
#   4. Never touches any other skill; never overwrites user modifications outside its own target.

param(
    [string]$SkillsRoot = (Join-Path $HOME ".agents\skills")
)

$ErrorActionPreference = "Stop"

$RepoRoot = $PSScriptRoot | Split-Path | Split-Path
if (-not (Test-Path (Join-Path $RepoRoot "SKILL.md"))) {
    # PSScriptRoot = <repo>\scripts when run from scripts\; fall back for direct invocation
    $RepoRoot = Split-Path $PSScriptRoot -Parent
    if (-not (Test-Path (Join-Path $RepoRoot "SKILL.md"))) {
        Write-Error "Cannot locate repository root (SKILL.md not found). Run via scripts\install.ps1."
        exit 1
    }
}

$UpstreamDir = Join-Path $SkillsRoot "official-document-writing"
$TargetDir = Join-Path $SkillsRoot "official-document-writing-tju"
$UpstreamUrl = "https://github.com/KaguraNanaga/official-document-writing-skill.git"

Write-Host "== TJU Official Document Writing Skill installer =="
Write-Host "Skills root : $SkillsRoot"

# 1) skills root
if (-not (Test-Path $SkillsRoot)) {
    New-Item -ItemType Directory -Path $SkillsRoot -Force | Out-Null
    Write-Host "[create] skills root created"
}

# 2) upstream dependency (clone once; never re-clone, never overwrite)
if (Test-Path (Join-Path $UpstreamDir "SKILL.md")) {
    Write-Host "[skip]    upstream already installed: $UpstreamDir"
} elseif (Test-Path $UpstreamDir) {
    Write-Warning "[warn]    $UpstreamDir exists but has no SKILL.md; leaving it untouched."
    Write-Warning "          Install upstream manually: git clone $UpstreamUrl `"$UpstreamDir`""
} else {
    Write-Host "[clone]   installing upstream dependency..."
    git clone $UpstreamUrl $UpstreamDir
    if ($LASTEXITCODE -ne 0) { Write-Error "git clone failed"; exit 1 }
}

# 3) install this skill (copy our own files only, force-overwrite OUR files, never others')
New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
Copy-Item (Join-Path $RepoRoot "SKILL.md") (Join-Path $TargetDir "SKILL.md") -Force
Copy-Item (Join-Path $RepoRoot "references") (Join-Path $TargetDir "references") -Recurse -Force
Copy-Item (Join-Path $RepoRoot "tju-extension") (Join-Path $TargetDir "tju-extension") -Recurse -Force
Write-Host "[install] official-document-writing-tju -> $TargetDir"

Write-Host "== done =="
Write-Host "Verify with: powershell -NoProfile -ExecutionPolicy Bypass -File scripts\verify_install.ps1 -SkillsRoot `"$SkillsRoot`""
