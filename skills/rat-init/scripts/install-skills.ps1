#Requires -Version 5.1
<#
.SYNOPSIS
    Install missing Rat-Coding skills non-interactively.

.DESCRIPTION
    Detects the skill manager and active editors from project markers, then
    installs the given skills project-scoped without interactive prompts.

.PARAMETER Skills
    One or more skill names to install (e.g. rat-feature rat-audit).

.EXAMPLE
    .\install-skills.ps1 rat-feature rat-audit rat-architecture rat-compaction

.NOTES
    Exit codes:
      0  All skills installed successfully
      1  Usage error (enforced by Mandatory parameter)
      2  Detection failed; manual instructions printed to stderr
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, ValueFromRemainingArguments)]
    [string[]] $Skills
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Repo = 'Maki-Daisuke/rat-coding'

# ── Manager detection ──────────────────────────────────────────────────────────
# Priority: APM → npx skills → gh skill → none
function Get-SkillManager {
    if ((Test-Path 'apm.lock.yaml') -or (Test-Path 'apm.yml')) { return 'apm' }
    if ((Test-Path 'skills-lock.json') -or (Test-Path '.skills.json')) { return 'npx-skills' }
    # gh skill injects Portable Provenance keys into each installed SKILL.md frontmatter.
    $hasProvenance = Get-ChildItem -Recurse -Filter 'SKILL.md' -ErrorAction SilentlyContinue |
    Select-String -Pattern 'github-repo|github-ref|github-tree-sha' -Quiet -ErrorAction SilentlyContinue
    if ($hasProvenance) { return 'gh-skill' }
    return $null
}

# ── Target detection ───────────────────────────────────────────────────────────
# Returns a PSCustomObject with:
#   NeedClaude  — bool: install to .claude/skills/ (claude-code)
#   NeedAgents  — bool: install to .agents/skills/ (all other agents at project scope)
#   ApmTargets  — string[]: APM --target values (APM uses per-client directories)
function Get-Targets {
    $result = [PSCustomObject]@{
        NeedClaude = $false
        NeedAgents = $false
        ApmTargets = [System.Collections.Generic.List[string]]::new()
    }

    if ((Test-Path '.claude') -or (Test-Path 'CLAUDE.md')) {
        $result.NeedClaude = $true
        $result.ApmTargets.Add('claude')
    }
    if (Test-Path '.github/copilot-instructions.md') {
        $result.NeedAgents = $true
        $result.ApmTargets.Add('copilot')
    }
    if (Test-Path '.cursor') {
        $result.NeedAgents = $true
        $result.ApmTargets.Add('cursor')
    }
    if (Test-Path '.codex') {
        $result.NeedAgents = $true
        $result.ApmTargets.Add('codex')
    }
    if (Test-Path '.opencode') {
        $result.NeedAgents = $true
        $result.ApmTargets.Add('opencode')
    }
    if (Test-Path '.windsurf') {
        $result.NeedAgents = $true
        $result.ApmTargets.Add('windsurf')
    }
    if ((Test-Path '.gemini') -or (Test-Path 'GEMINI.md')) {
        $result.NeedAgents = $true
        $result.ApmTargets.Add('gemini')
    }
    if (Test-Path '.agents') {
        $result.NeedAgents = $true
        $result.ApmTargets.Add('agent-skills')
    }

    $result.ApmTargets = @($result.ApmTargets | Sort-Object -Unique)
    return $result
}

# ── Fallback instructions ──────────────────────────────────────────────────────
function Write-ManualInstructions {
    $skillFlags = ($Skills | ForEach-Object { "--skill $_" }) -join ' '
    Write-Host ''
    Write-Host 'Please install the skills manually using one of:' -ForegroundColor Yellow
    Write-Host "  (gh skill)   gh skill install $Repo <skill> --agent <agent> --scope project"
    Write-Host "  (npx skills) npx skills add $Repo $skillFlags -a <agent> -y"
    Write-Host "  (apm)        apm install $Repo $skillFlags --target <target>"
    Write-Host ''
    Write-Host 'gh skill / npx skills agents: claude-code  github-copilot  cursor  codex  opencode  windsurf  gemini-cli  amp'
    Write-Host 'apm targets:                   claude  copilot  cursor  codex  opencode  windsurf  gemini  agent-skills'
}

# ── Main ───────────────────────────────────────────────────────────────────────

$manager = Get-SkillManager
if (-not $manager) {
    Write-Host 'ERROR: Could not detect skill manager.' -ForegroundColor Red
    Write-Host 'No markers found: apm.lock.yaml/apm.yml (APM), skills-lock.json/.skills.json (npx skills),'
    Write-Host 'or Portable Provenance keys in any SKILL.md (gh skill).'
    Write-ManualInstructions
    exit 2
}

$targets = Get-Targets
if (-not $targets.NeedClaude -and -not $targets.NeedAgents) {
    Write-Host 'ERROR: Could not detect any editor/agent in this project.' -ForegroundColor Red
    Write-Host 'No markers found: .claude/, CLAUDE.md, .cursor/, .github/copilot-instructions.md,'
    Write-Host '.codex/, .opencode/, .windsurf/, .gemini/, GEMINI.md, .agents/'
    Write-ManualInstructions
    exit 2
}

$editorDesc = @()
if ($targets.NeedClaude) { $editorDesc += 'claude-code (.claude/skills/)' }
if ($targets.NeedAgents) { $editorDesc += '.agents/skills/ compatible' }

Write-Host "Detected skill manager : $manager"
Write-Host "Detected editors       : $($editorDesc -join ', ')"
Write-Host ''

# Build the --skill flag pairs array used by apm and npx-skills
$skillFlagsArr = @(foreach ($s in $Skills) { '--skill'; $s })

switch ($manager) {

    'apm' {
        $targetStr = $targets.ApmTargets -join ','
        Write-Host "Running: apm install $Repo $($skillFlagsArr -join ' ') --target $targetStr"
        & apm install $Repo @skillFlagsArr --target $targetStr
    }

    'npx-skills' {
        # npx skills: Claude → .claude/skills/; everything else → .agents/skills/.
        # Use one representative agent per destination; npx skills installs once per destination.
        $agentFlagsArr = [System.Collections.Generic.List[string]]::new()
        if ($targets.NeedClaude) { $agentFlagsArr.AddRange([string[]]@('-a', 'claude-code')) }
        if ($targets.NeedAgents) { $agentFlagsArr.AddRange([string[]]@('-a', 'github-copilot')) }
        $agentArr = $agentFlagsArr.ToArray()
        Write-Host "Running: npx skills add $Repo $($skillFlagsArr -join ' ') $($agentArr -join ' ') -y"
        & npx skills add $Repo @skillFlagsArr @agentArr -y
    }

    'gh-skill' {
        # gh skill: Claude → .claude/skills/; everything else → .agents/skills/ (all agents share it).
        # Use github-copilot as the representative .agents/ agent; one install covers all.
        foreach ($skill in $Skills) {
            if ($targets.NeedClaude) {
                Write-Host "Running: gh skill install $Repo $skill --agent claude-code --scope project"
                & gh skill install $Repo $skill --agent claude-code --scope project
            }
            if ($targets.NeedAgents) {
                Write-Host "Running: gh skill install $Repo $skill --agent github-copilot --scope project"
                & gh skill install $Repo $skill --agent github-copilot --scope project
            }
        }
    }

}

Write-Host ''
Write-Host "Done. Skills installed: $($Skills -join ', ')"
