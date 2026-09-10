#!/bin/sh
set -eu

LABS_ROOT=${LABS_ROOT:-/labs}
enabled="$LABS_ROOT/runtime/enabled-demos"

[ -f "$enabled" ] || exit 0

while IFS= read -r slug; do
  case "$slug" in
    ''|*[!a-z0-9-]*|-*|*--) continue ;;
  esac
  start_script="$LABS_ROOT/demos/$slug/start.sh"
  if [ -x "$start_script" ]; then
    "$start_script" --restore
  fi
done < "$enabled"
