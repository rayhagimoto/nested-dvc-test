#!/usr/bin/env bash
set -euo pipefail

arg="${1:?usage: ./setup-example.sh <suffix>}"
dir="cool-example-$arg"

git clone https://github.com/treeverse/example-get-started.git "$dir"
cd "$dir"
rm -rf .git/ .dvc/
git init
dvc init --subdir
curl -fsSL https://raw.githubusercontent.com/treeverse/example-get-started/refs/heads/main/.dvc/config > .dvc/config
dvc pull
git add .
git commit -m "init dvc subdir example"
dvc exp run -n "exp-$arg"
