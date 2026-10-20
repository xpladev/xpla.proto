#!/usr/bin/env bash
set -euo pipefail
JS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$JS_DIR"
# package.json is the single list of generated directories shipped to consumers.
DIR_LIST="$(node -e 'for (const entry of require("./package.json").files) if (entry.endsWith("/")) console.log(entry.slice(0, -1))')"
mapfile -t DIRS <<< "$DIR_LIST"
for dir in "${DIRS[@]}"; do
  [[ "$dir" =~ ^[a-z_]+$ && -d "build/$dir" ]] || { echo "Missing or invalid package directory: $dir" >&2; exit 1; }
done
for dir in "${DIRS[@]}"; do
  rm -rf -- "$dir"
  cp -R -- "build/$dir" "$dir"
done
