gpatch() {
  gnuke
  git switch main
  git pull

  local ts="jg-$(date +%F_%H-%M)"
  git switch -c "$ts"
}