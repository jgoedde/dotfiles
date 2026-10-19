#!/bin/bash
# Last synced with https://www.aihero.dev/creating-the-perfect-claude-code-status-line#step-4-create-the-wrapper-script
# at 2026-10-19

# Read JSON input once
input=$(cat)

# Get git info from existing script
git_info=$(echo "$input" | bash ~/.claude/statusline-command.sh)

# Get context percentage from ccstatusline
context_pct=$(echo "$input" | npx ccstatusline)

# Combine outputs
printf '%s | %s' "$git_info" "$context_pct"