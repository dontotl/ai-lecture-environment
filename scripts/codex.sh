#!/bin/sh
set -eu

env_file='env/macos-arm64.env'

usage() {
  echo "Usage: $0 [--env-file PATH] [--] [codex arguments]" >&2
  exit 2
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --env-file)
      shift
      [ "$#" -gt 0 ] || usage
      env_file=$1
      shift
      ;;
    --help|-h)
      usage
      ;;
    --)
      shift
      break
      ;;
    *) break ;;
  esac
done

exec docker compose --env-file "$env_file" exec -it app codex "$@"
