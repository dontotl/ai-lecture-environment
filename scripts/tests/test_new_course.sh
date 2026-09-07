#!/bin/sh
set -eu

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
scratch_dir=$(mktemp -d)
trap 'rm -rf "$scratch_dir"' EXIT

"$project_root/scripts/new-course.sh" --root "$scratch_dir" --id 01 --slug oracle-basics --title "Oracle 기초"

course_dir="$scratch_dir/courses/01-oracle-basics"
test -f "$course_dir/README.md"
test -d "$course_dir/lab"
test -d "$course_dir/assets"
test -d "$course_dir/checks"
! test -d "$course_dir/solution"
grep -F "# 01. Oracle 기초" "$course_dir/README.md" >/dev/null
