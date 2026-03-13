#!/usr/bin/env bash

set -u

render_notebook() {
  local notebook_path="$1"
  local notebook_dir
  local notebook_name
  local notebook_stem
  local temp_dir
  local temp_ipynb
  local render_log

  notebook_dir="$(dirname "$notebook_path")"
  notebook_name="$(basename "$notebook_path")"
  notebook_stem="${notebook_name%.py}"
  temp_dir="$(mktemp -d)"
  temp_ipynb="$temp_dir/${notebook_stem}.ipynb"
  render_log="$temp_dir/render.log"

  mkdir -p "${notebook_dir}/figs"

  echo "Rendering ${notebook_path}"

  if ! uv run marimo export ipynb "$notebook_path" -o "$temp_ipynb" --sort=top-down --include-outputs >"$render_log" 2>&1; then
    echo "Skipping ${notebook_path}: marimo export failed"
    cat "$render_log"
    rm -rf "$temp_dir"
    return 1
  fi

  if ! uv run jupyter nbconvert --to markdown --config nbconvert_config.py "$temp_ipynb" --output-dir "$temp_dir" >>"$render_log" 2>&1; then
    echo "Skipping ${notebook_path}: nbconvert failed"
    cat "$render_log"
    rm -rf "$temp_dir"
    return 1
  fi

  if [ -f "$temp_dir/${notebook_stem}.md" ]; then
    mv "$temp_dir/${notebook_stem}.md" "${notebook_dir}/${notebook_stem}.md"
  fi

  if [ -d "$temp_dir/figs" ]; then
    cp -R "$temp_dir/figs/." "${notebook_dir}/figs/"
  fi

  rm -f "${notebook_dir}/${notebook_stem}.ipynb"
  rm -rf "$temp_dir"
  return 0
}

main() {
  local notebook_paths=()
  local notebook_path
  local failures=0

  if [ "$#" -gt 0 ]; then
    notebook_paths=("$@")
  else
    while IFS= read -r notebook_path; do
      notebook_paths+=("$notebook_path")
    done < <(find notebooks -maxdepth 1 -type f -name "*.py" | sort)
  fi

  if [ "${#notebook_paths[@]}" -eq 0 ]; then
    echo "No notebooks found."
    return 0
  fi

  for notebook_path in "${notebook_paths[@]}"; do
    if ! render_notebook "$notebook_path"; then
      failures=$((failures + 1))
    fi
  done

  if [ "$failures" -gt 0 ]; then
    echo "${failures} notebook render(s) failed. Continuing without failing the job."
  fi

  return 0
}

main "$@"
