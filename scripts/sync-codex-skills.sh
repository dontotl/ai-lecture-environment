#!/bin/sh
set -eu

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
manifest="$project_root/infra/codex-profile/skill-manifest.txt"
destination="$project_root/infra/codex-profile/skills"

rm -rf "$destination"
mkdir -p "$destination"

while IFS= read -r skill; do
  [ -n "$skill" ] || continue
  source="$project_root/.codex/skills/$skill"
  if [ ! -f "$source/SKILL.md" ]; then
    echo "Missing skill source: $skill" >&2
    exit 1
  fi
  cp -RL "$source" "$destination/$skill"
  test -f "$destination/$skill/SKILL.md"
done < "$manifest"

expected=$(grep -cve '^[[:space:]]*$' "$manifest")
actual=$(find "$destination" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
test "$expected" = "$actual"
echo "Copied $actual Codex skills"
