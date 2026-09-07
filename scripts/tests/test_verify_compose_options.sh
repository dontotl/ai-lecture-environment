#!/bin/sh
set -eu

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)

if "$project_root/scripts/verify-compose.sh" env/macos-arm64.env --require-skills; then
  echo "student verification must reject instructor-only options" >&2
  exit 1
fi
