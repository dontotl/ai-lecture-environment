#!/bin/sh
set -eu

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)

rg -F '${HOME}/.codex/auth.json:/tmp/codex-home/auth.json' "$project_root/compose.yaml"
if rg -F '${HOME}/.codex/auth.json:/tmp/codex-home/auth.json:ro' "$project_root/compose.yaml"; then
  echo 'Codex auth mount must be writable for container login.' >&2
  exit 1
fi
rg -F 'find "$CODEX_HOME" -mindepth 1 -maxdepth 1 ! -name auth.json -exec rm -rf {} +' "$project_root/infra/app/entrypoint.sh"
rg -F 'chown -R app:app "$CODEX_HOME"/config.toml' "$project_root/infra/app/entrypoint.sh"
