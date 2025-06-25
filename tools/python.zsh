function venv {
  local venv_dir current_dir
  current_dir=$(pwd)

  # Search for .venv in current and parent directories
  while [[ "$current_dir" != "/" ]]; do
    if [[ -d "$current_dir/.venv" ]]; then
      venv_dir="$current_dir/.venv"
      break
    fi
    current_dir=$(dirname "$current_dir")
  done

  if [[ ! -d "$venv_dir" ]]; then
    echo "Creating virtual environment in .venv"
    python3 -m venv .venv
    venv_dir=".venv"
  fi

  source "$venv_dir/bin/activate"
}
