#!/bin/bash
# Last synced with https://www.aihero.dev/creating-the-perfect-claude-code-status-line#step-3-create-the-git-status-script
# at 2026-10-19

# Read JSON input
input=$(cat)

# Extract values from JSON (without jq)
cwd=$(echo "$input" | sed -n 's/.*"current_dir":"\([^"]*\)".*/\1/p')

# Git information (skip optional locks for performance)
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  # Get repo name relative to ~/repos/
  repo_name=$(echo "$cwd" | sed "s|^$HOME/repos/||")

  # Get branch
  branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)

  printf '\033[01;36m%s\033[00m | \033[01;32m%s\033[00m' \
    "$repo_name" "$branch"
else
  # Not a git repo
  printf '\033[01;36m%s\033[00m' "$cwd"
fi

# Caveman plugin mode (per-session file, falls back to global flag)
cfg="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
session_id=$(echo "$input" | sed -n 's/.*"session_id":"\([A-Za-z0-9_-]*\)".*/\1/p')
caveman_flag="$cfg/.caveman-active"
if [ -n "$session_id" ] && [ -f "$cfg/.caveman-sessions/$session_id.mode" ]; then
  caveman_flag="$cfg/.caveman-sessions/$session_id.mode"
fi
caveman_mode=""
if [ -f "$caveman_flag" ] && [ ! -L "$caveman_flag" ]; then
  caveman_mode=$(head -c 64 "$caveman_flag" | tr -cd 'a-z0-9-')
fi
case "$caveman_mode" in
  ''|off) printf ' | \033[02mCV: off\033[00m' ;;
  caveman|lite|full) printf ' | \033[38;5;172mCV\033[00m' ;;
  *) printf ' | \033[38;5;172mCV: %s\033[00m' "$caveman_mode" ;;
esac
