gnuke() {
  local skip_prompts=0

  # Parse flags
  if [[ "$1" == "--yes" || "$1" == "-y" ]]; then
    skip_prompts=1
  fi

  if (( !skip_prompts )); then
    echo "WARNING: This will irreversibly delete all local changes and untracked files."
    read -q "REPLY?Are you sure? (y/n) "
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Aborted."
      return 1
    fi
  fi

  git reset --hard HEAD && git clean -fd
  echo "Nuked local changes."

  local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  local remote_ref=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)

  if [[ -z "$remote_ref" ]]; then
    return 0
  fi

  local local_commit=$(git rev-parse HEAD)
  local remote_commit=$(git rev-parse "$remote_ref")

  if [[ "$local_commit" != "$remote_commit" ]]; then
    if (( skip_prompts )); then
      git reset --hard "$remote_ref"
      echo "Reset to $remote_ref."
    else
      echo
      echo "WARNING: Local branch '$branch' has diverged from '$remote_ref'."
      echo "  Local:  $(git log -1 --oneline HEAD)"
      echo "  Remote: $(git log -1 --oneline $remote_ref)"
      read -q "REPLY?Reset local branch to match remote? (y/n) "
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        git reset --hard "$remote_ref"
        echo "Reset to $remote_ref."
      else
        echo "Left as-is."
      fi
    fi
  fi
}