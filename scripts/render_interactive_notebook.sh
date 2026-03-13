#!/usr/bin/env bash

set -u

strict_mode="${RENDER_NOTEBOOKS_STRICT:-0}"

find_project_root() {
  local search_dir="$1"

  while [ "$search_dir" != "." ] && [ "$search_dir" != "/" ]; do
    if [ -f "$search_dir/pyproject.toml" ] && [ -f "$search_dir/nbconvert_config.py" ]; then
      printf '%s\n' "$search_dir"
      return 0
    fi

    search_dir="$(dirname "$search_dir")"
  done

  if [ -f "./pyproject.toml" ] && [ -f "./nbconvert_config.py" ]; then
    printf '.\n'
    return 0
  fi

  return 1
}

render_notebook() {
  local notebook_path="$1"
  local project_root
  local notebook_dir
  local notebook_name
  local notebook_stem
  local normalized_notebook_path
  local normalized_project_root
  local relative_notebook_path
  local temp_dir
  local temp_ipynb
  local render_log

  if ! project_root="$(find_project_root "$(dirname "$notebook_path")")"; then
    echo "Skipping ${notebook_path}: could not locate project root with pyproject.toml and nbconvert_config.py"
    return 1
  fi

  normalized_notebook_path="${notebook_path#./}"
  normalized_project_root="${project_root#./}"

  relative_notebook_path="$normalized_notebook_path"
  if [ "$normalized_project_root" != "." ] && [ "$normalized_project_root" != "$project_root" ]; then
    relative_notebook_path="${normalized_notebook_path#"$normalized_project_root"/}"
  elif [ "$project_root" != "." ]; then
    relative_notebook_path="${normalized_notebook_path#"$project_root"/}"
  fi

  notebook_dir="$project_root/$(dirname "$relative_notebook_path")"
  notebook_name="$(basename "$notebook_path")"
  notebook_stem="${notebook_name%.py}"
  temp_dir="$(mktemp -d)"
  temp_ipynb="$temp_dir/${notebook_stem}.ipynb"
  render_log="$temp_dir/render.log"

  mkdir -p "${notebook_dir}/figs"

  echo "Rendering ${notebook_path}"

  if ! (
    cd "$project_root" &&
    uv run marimo export ipynb "$relative_notebook_path" -o "$temp_ipynb" --sort=top-down --include-outputs
  ) >"$render_log" 2>&1; then
    echo "Skipping ${notebook_path}: marimo export failed"
    cat "$render_log"
    rm -rf "$temp_dir"
    return 1
  fi

  if ! (
    cd "$project_root" &&
    uv run jupyter nbconvert --to markdown --config nbconvert_config.py "$temp_ipynb" --output-dir "$temp_dir"
  ) >>"$render_log" 2>&1; then
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
    while IFS= read -r -d '' notebook_path; do
      notebook_paths+=("$notebook_path")
    done < <(find . -path '*/notebooks/*.py' -print0 | sort -z)
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
    echo "${failures} notebook render(s) failed."
    if [ "$strict_mode" = "1" ]; then
      return 1
    fi

    echo "Continuing without failing the job."
  fi

  return 0
}

main "$@"
