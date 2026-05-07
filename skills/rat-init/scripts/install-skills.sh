#!/usr/bin/env bash
# install-skills.sh — Install missing Rat-Coding skills non-interactively.
#
# Detects the skill manager and active editors from project markers, then
# installs the given skills project-scoped without interactive prompts.
#
# Usage:    ./install-skills.sh <skill> [<skill> ...]
# Example:  ./install-skills.sh rat-feature rat-audit rat-architecture rat-compaction
#
# Exit codes:
#   0  All skills installed successfully
#   1  Usage error
#   2  Detection failed; manual instructions printed to stderr

set -euo pipefail

REPO="Maki-Daisuke/rat-coding"

if [[ $# -eq 0 ]]; then
  echo "Usage: install-skills.sh <skill> [<skill> ...]" >&2
  exit 1
fi

SKILLS=("$@")

# ── Manager detection ──────────────────────────────────────────────────────────
# Priority: APM → npx skills → gh skill → none
detect_manager() {
  if [[ -f "apm.lock.yaml" || -f "apm.yml" ]]; then
    echo "apm"; return
  fi
  if [[ -f "skills-lock.json" || -f ".skills.json" ]]; then
    echo "npx-skills"; return
  fi
  # gh skill injects Portable Provenance keys into each installed SKILL.md frontmatter.
  if find . -name "SKILL.md" 2>/dev/null \
       | xargs grep -ql "github-repo\|github-ref\|github-tree-sha" 2>/dev/null; then
    echo "gh-skill"; return
  fi
  echo ""
}

# ── Target detection ───────────────────────────────────────────────────────────
# Sets globals:
#   NEED_CLAUDE  — true if .claude/ or CLAUDE.md present → installs to .claude/skills/
#   NEED_AGENTS  — true if any .agents/-compatible marker present → installs to .agents/skills/
#   APM_TARGETS  — comma-separated APM --target value (APM uses per-client directories)
detect_targets() {
  NEED_CLAUDE=false
  NEED_AGENTS=false
  local -a apm=()

  if [[ -d ".claude" || -f "CLAUDE.md" ]]; then
    NEED_CLAUDE=true; apm+=("claude")
  fi
  if [[ -f ".github/copilot-instructions.md" ]]; then
    NEED_AGENTS=true; apm+=("copilot")
  fi
  if [[ -d ".cursor" ]]; then
    NEED_AGENTS=true; apm+=("cursor")
  fi
  if [[ -d ".codex" ]]; then
    NEED_AGENTS=true; apm+=("codex")
  fi
  if [[ -d ".opencode" ]]; then
    NEED_AGENTS=true; apm+=("opencode")
  fi
  if [[ -d ".windsurf" ]]; then
    NEED_AGENTS=true; apm+=("windsurf")
  fi
  if [[ -d ".gemini" || -f "GEMINI.md" ]]; then
    NEED_AGENTS=true; apm+=("gemini")
  fi
  if [[ -d ".agents" ]]; then
    NEED_AGENTS=true; apm+=("agent-skills")
  fi

  if [[ ${#apm[@]} -gt 0 ]]; then
    APM_TARGETS=$(printf '%s\n' "${apm[@]}" | sort -u | paste -sd,)
  else
    APM_TARGETS=""
  fi
}

# ── Fallback instructions ──────────────────────────────────────────────────────
print_manual_instructions() {
  local skill_flags
  skill_flags=$(printf -- '--skill %s ' "${SKILLS[@]}")
  printf '\nPlease install the skills manually using one of:\n' >&2
  printf '  (gh skill)   gh skill install %s <skill> --agent <agent> --scope project\n' "$REPO" >&2
  printf '  (npx skills) npx skills add %s %s-a <agent> -y\n' "$REPO" "$skill_flags" >&2
  printf '  (apm)        apm install %s %s--target <target>\n' "$REPO" "$skill_flags" >&2
  printf '\ngh skill / npx skills agents: claude-code  github-copilot  cursor  codex  opencode  windsurf  gemini-cli  amp\n' >&2
  printf 'apm targets:                   claude  copilot  cursor  codex  opencode  windsurf  gemini  agent-skills\n' >&2
}

# ── Main ───────────────────────────────────────────────────────────────────────

MANAGER=$(detect_manager)
if [[ -z "$MANAGER" ]]; then
  printf 'ERROR: Could not detect skill manager.\n' >&2
  printf 'No markers found: apm.lock.yaml/apm.yml (APM), skills-lock.json/.skills.json (npx skills),\n' >&2
  printf 'or Portable Provenance keys in any SKILL.md (gh skill).\n' >&2
  print_manual_instructions
  exit 2
fi

detect_targets
if [[ "$NEED_CLAUDE" == false && "$NEED_AGENTS" == false ]]; then
  printf 'ERROR: Could not detect any editor/agent in this project.\n' >&2
  printf 'No markers found: .claude/, CLAUDE.md, .cursor/, .github/copilot-instructions.md,\n' >&2
  printf '.codex/, .opencode/, .windsurf/, .gemini/, GEMINI.md, .agents/\n' >&2
  print_manual_instructions
  exit 2
fi

editor_desc=""
[[ "$NEED_CLAUDE" == true ]] && editor_desc+="claude-code (.claude/skills/)"
[[ "$NEED_AGENTS" == true ]] && editor_desc+="${editor_desc:+, }.agents/skills/ compatible"

printf 'Detected skill manager : %s\n' "$MANAGER"
printf 'Detected editors       : %s\n' "$editor_desc"
printf '\n'

# Build --skill flag pairs (used by apm and npx-skills)
skill_flags=()
for s in "${SKILLS[@]}"; do skill_flags+=("--skill" "$s"); done

case "$MANAGER" in

  apm)
    printf 'Running: apm install %s %s --target %s\n' "$REPO" "${skill_flags[*]}" "$APM_TARGETS"
    apm install "$REPO" "${skill_flags[@]}" --target "$APM_TARGETS"
    ;;

  npx-skills)
    # npx skills: Claude → .claude/skills/; everything else → .agents/skills/.
    # Use one representative agent per destination; npx skills installs once per destination.
    agent_flags=()
    [[ "$NEED_CLAUDE" == true ]] && agent_flags+=("-a" "claude-code")
    [[ "$NEED_AGENTS" == true ]] && agent_flags+=("-a" "github-copilot")
    printf 'Running: npx skills add %s %s %s -y\n' "$REPO" "${skill_flags[*]}" "${agent_flags[*]}"
    npx skills add "$REPO" "${skill_flags[@]}" "${agent_flags[@]}" -y
    ;;

  gh-skill)
    # gh skill: Claude → .claude/skills/; everything else → .agents/skills/ (all agents share it).
    # Use github-copilot as the representative .agents/ agent; one install covers all.
    for s in "${SKILLS[@]}"; do
      if [[ "$NEED_CLAUDE" == true ]]; then
        printf 'Running: gh skill install %s %s --agent claude-code --scope project\n' "$REPO" "$s"
        gh skill install "$REPO" "$s" --agent claude-code --scope project
      fi
      if [[ "$NEED_AGENTS" == true ]]; then
        printf 'Running: gh skill install %s %s --agent github-copilot --scope project\n' "$REPO" "$s"
        gh skill install "$REPO" "$s" --agent github-copilot --scope project
      fi
    done
    ;;

esac

printf '\nDone. Skills installed: %s\n' "${SKILLS[*]}"
