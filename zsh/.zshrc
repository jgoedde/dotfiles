ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Load shipped files in order, unless a same-named override exists in custom/
for f in "$ZSH_CONFIG_DIR"/*.zsh(N); do
  name=$(basename "$f")
  if [[ -f "$ZSH_CONFIG_DIR/custom/$name" ]]; then
    source "$ZSH_CONFIG_DIR/custom/$name"
  else
    source "$f"
  fi
done

# Load any extra custom files that aren't overrides (new additions)
for f in "$ZSH_CONFIG_DIR"/custom/*.zsh(N); do
  name=$(basename "$f")
  [[ -f "$ZSH_CONFIG_DIR/$name" ]] || source "$f"
done
