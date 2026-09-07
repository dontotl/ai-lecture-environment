#!/bin/sh
set -eu

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
scratch_dir=$(mktemp -d)
trap 'rm -rf "$scratch_dir"' EXIT

mkdir -p "$scratch_dir/scripts" "$scratch_dir/infra/codex-profile/skills" "$scratch_dir/.codex/skills"
cp "$project_root/scripts/sync-codex-skills.sh" "$scratch_dir/scripts/sync-codex-skills.sh"
cp "$project_root/infra/codex-profile/skill-manifest.txt" "$scratch_dir/infra/codex-profile/skill-manifest.txt"
touch "$scratch_dir/infra/codex-profile/skills/.gitkeep"

while IFS= read -r skill; do
  mkdir -p "$scratch_dir/.codex/skills/$skill"
  touch "$scratch_dir/.codex/skills/$skill/SKILL.md"
done < "$scratch_dir/infra/codex-profile/skill-manifest.txt"

sh "$scratch_dir/scripts/sync-codex-skills.sh"

test -f "$scratch_dir/infra/codex-profile/skills/.gitkeep"
