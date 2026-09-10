#!/bin/sh
set -eu

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
config=$(cd "$project_root" && docker compose --env-file env/macos-arm64.env config)

printf '%s\n' "$config" | grep -F 'target: /labs' >/dev/null
printf '%s\n' "$config" | grep -F 'published: "8080"' >/dev/null
if printf '%s\n' "$config" | grep -Eq 'published: "(8000|5173)"'; then
  echo 'app must expose only port 8080' >&2
  exit 1
fi
