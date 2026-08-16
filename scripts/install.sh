#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./scripts/install.sh [all|skills|plugins]

Install the versioned local skills and/or restore the enabled-plugin set from
this repository. Existing skill directories are never overwritten.
EOF
}

mode="${1:-all}"
case "$mode" in
  all|skills|plugins) ;;
  -h|--help) usage; exit 0 ;;
  *) usage >&2; exit 2 ;;
esac

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
codex_root="${CODEX_HOME:-"${HOME}/.codex"}"
skills_destination="${codex_root}/skills"

install_skills() {
  mkdir -p "$skills_destination"

  local skill
  for skill in codex-ppt frontend-slides handdrawn-tech-illustrations image-to-editable-ppt ppt-master; do
    local source="${repository_root}/skills/${skill}"
    local destination="${skills_destination}/${skill}"

    if [[ -e "$destination" ]]; then
      printf 'Skipping existing skill: %s\n' "$destination"
      continue
    fi

    rsync -a "${source}/" "${destination}/"
    printf 'Installed skill: %s\n' "$skill"
  done
}

install_plugins() {
  command -v codex >/dev/null || {
    printf 'The Codex CLI is required to restore plugins.\n' >&2
    exit 1
  }

  local plugin
  local -a plugins=(
    documents@openai-primary-runtime
    pdf@openai-primary-runtime
    spreadsheets@openai-primary-runtime
    presentations@openai-primary-runtime
    template-creator@openai-primary-runtime
    sites@openai-bundled
    browser@openai-bundled
    chrome@openai-bundled
    visualize@openai-bundled
    google-calendar@openai-curated
    slack@openai-curated
  )

  for plugin in "${plugins[@]}"; do
    codex plugin add "$plugin"
  done

  cat <<'EOF'

Plugins installed. Sign in to Google Calendar and Slack again in Codex; this
repository deliberately does not contain OAuth tokens, browser profiles, or
other credentials.
EOF
}

if [[ "$mode" == "all" || "$mode" == "skills" ]]; then
  install_skills
fi

if [[ "$mode" == "all" || "$mode" == "plugins" ]]; then
  install_plugins
fi
