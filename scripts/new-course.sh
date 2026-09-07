#!/bin/sh
set -eu

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
root="$project_root"
course_id=""
slug=""
title=""

usage() {
  echo "Usage: $0 [--root PATH] --id NN --slug topic-slug --title TITLE" >&2
  exit 2
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --root) root="$2"; shift 2 ;;
    --id) course_id="$2"; shift 2 ;;
    --slug) slug="$2"; shift 2 ;;
    --title) title="$2"; shift 2 ;;
    *) usage ;;
  esac
done

[ -n "$course_id" ] && [ -n "$slug" ] && [ -n "$title" ] || usage
case "$course_id" in *[!0-9]*|"") usage ;; esac
case "$slug" in *[!a-z0-9-]*|"") usage ;; esac

template="$project_root/courses/_template"
target="$root/courses/$course_id-$slug"
[ -d "$template" ] || { echo "Missing course template: $template" >&2; exit 1; }
[ ! -e "$target" ] || { echo "Course already exists: $target" >&2; exit 1; }

mkdir -p "$root/courses"
cp -R "$template" "$target"
awk -v id="$course_id" -v course_title="$title" \
  '{ gsub("{{COURSE_ID}}", id); gsub("{{COURSE_TITLE}}", course_title); print }' \
  "$target/README.md" > "$target/README.md.tmp"
mv "$target/README.md.tmp" "$target/README.md"
