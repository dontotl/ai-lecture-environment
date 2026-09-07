#!/bin/sh
set -eu

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
empty_skills=$(mktemp -d)
trap 'rm -rf "$empty_skills"' EXIT

if SKILLS_DIR="$empty_skills" "$project_root/scripts/verify-compose.sh" env/macos-arm64.env --require-skills; then
  echo "--require-skills must fail when the supplied skill directory is empty" >&2
  exit 1
fi
