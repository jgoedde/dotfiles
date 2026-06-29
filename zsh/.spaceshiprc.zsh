# Disable async prompt. See https://github.com/spaceship-prompt/spaceship-prompt/issues/1193
SPACESHIP_PROMPT_ASYNC=false
SPACESHIP_PACKAGE_SHOW_PRIVATE=true
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_PROMPT_ADD_NEWLINE=false

SPACESHIP_PROMPT_ORDER=(
  time           # Time stamps section
  user           # Username section
  dir            # Current directory section
  host           # Hostname section
  git            # Git section (git_branch + git_status)
  package        # Package version
  node           # Node.js section
  bun            # Bun section
  deno           # Deno section
  python         # Python section
  docker         # Docker section
  docker_compose # Docker section
  venv           # virtualenv section
  conda          # conda virtualenv section
  uv             # uv section
  dotnet         # .NET section
  exec_time      # Execution time
  line_sep       # Line break
  battery        # Battery level and status
  jobs           # Background jobs indicator
  exit_code      # Exit code section
  sudo           # Sudo indicator
  char           # Prompt character
)
