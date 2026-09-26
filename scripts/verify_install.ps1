# Verify script for TJU-Official-Document-Writing-Skill installation (read-only).
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\verify_install.ps1
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\verify_install.ps1 -SkillsRoot "D:\custom\skills"

param(
    [string]$SkillsRoot = (Join-Path $HOME ".agents\skills")
)

$ErrorActionPreference = "Stop"
$TargetDir = Join-Path $SkillsRoot "official-document-writing-tju"
$UpstreamDir = Join-Path $SkillsRoot "official-document-writing"

$checks = @(
    @{ Name = "upstream SKILL.md";                Path = (Join-Path $UpstreamDir "SKILL.md") },
    @{ Name = "upstream quality checklist";       Path = (Join-Path $UpstreamDir "checklists\quality-checklist.md") },
    @{ Name = "installed SKILL.md";               Path = (Join-Path $TargetDir "SKILL.md") },
    @{ Name = "references: personal statement";   Path = (Join-Path $TargetDir "references\postgraduate_personal_statement.md") },
    @{ Name = "references: research experience";  Path = (Join-Path $TargetDir "references\research_experience_summary.md") },
    @{ Name = "references: internship";           Path = (Join-Path $TargetDir "references\internship_summary.md") },
    @{ Name = "references: competition";          Path = (Join-Path $TargetDir "references\competition_summary.md") },
    @{ Name = "references: completion report";    Path = (Join-Path $TargetDir "references\project_completion_report.md") },
    @{ Name = "references: defense script";       Path = (Join-Path $TargetDir "references\defense_script.md") },
    @{ Name = "tju-extension README";             Path = (Join-Path $TargetDir "tju-extension\README.md") },
    @{ Name = "tju-extension scenarios";          Path = (Join-Path $TargetDir "tju-extension\references\tju-academic-scenarios.md") }
)

$failed = 0
foreach ($c in $checks) {
    if (Test-Path $c.Path) {
        Write-Host "[ok]   $($c.Name)"
    } else {
        Write-Host "[FAIL] $($c.Name)  ->  $($c.Path)"
        $failed++
    }
}

if ($failed -eq 0) {
    Write-Host "== VERIFY PASS: all $($checks.Count) checks ok =="
    exit 0
} else {
    Write-Host "== VERIFY FAILED: $failed of $($checks.Count) checks missing =="
    exit 1
}
