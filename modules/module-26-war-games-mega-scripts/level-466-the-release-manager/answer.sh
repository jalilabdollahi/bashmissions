#!/usr/bin/env bash
# Release manager: version from commits, changelog, artifacts, tag, announcement.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--dry-run] [--notify URL] APP" >&2
  exit 2
}

dry=0
notify=
while (( $# > 0 )); do
  case $1 in
    --dry-run) dry=1; shift ;;
    --notify)
      [[ -n ${2:-} ]] || usage
      notify=$2
      shift 2
      ;;
    -*) usage ;;
    *) break ;;
  esac
done
[[ $# -eq 1 ]] || usage
app=$1

fail() { echo "error: $1" >&2; exit "${2:-3}"; }

# 1. clean tree
[[ -z $(git status --porcelain) ]] || fail "working tree is not clean"

# 2. last tag and range
old_major=0 old_minor=0 old_patch=0
if last=$(git describe --tags --abbrev=0 2> /dev/null); then
  if [[ ! $last =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    fail "last tag '$last' is not vMAJOR.MINOR.PATCH"
  fi
  old_major=${BASH_REMATCH[1]} old_minor=${BASH_REMATCH[2]} old_patch=${BASH_REMATCH[3]}
  range="$last..HEAD"
else
  last=
  range=HEAD
fi
old="v$old_major.$old_minor.$old_patch"

# 3. commits
subjects=$(git log --pretty=format:%s "$range")
if [[ -z $subjects ]]; then
  if [[ -n $last ]]; then echo "nothing to release since $last" >&2; else echo "nothing to release" >&2; fi
  exit 4
fi

# 4. classify
breaking=() feats=() fixes=() other=()
re='^([a-z]+)(\(([^)]*)\))?(!)?: (.+)$'
while IFS= read -r subject; do
  if [[ $subject =~ $re ]]; then
    type=${BASH_REMATCH[1]} scope=${BASH_REMATCH[3]} bang=${BASH_REMATCH[4]} text=${BASH_REMATCH[5]}
    item=$text
    [[ -z $scope ]] || item="($scope) $text"
    if [[ -n $bang ]]; then breaking+=("$item")
    elif [[ $type == feat ]]; then feats+=("$item")
    elif [[ $type == fix ]]; then fixes+=("$item")
    else other+=("$subject")
    fi
  else
    other+=("$subject")
  fi
done <<< "$subjects"

# 5. next version
if (( ${#breaking[@]} > 0 )); then
  next="$((old_major + 1)).0.0"
elif (( ${#feats[@]} > 0 )); then
  next="$old_major.$((old_minor + 1)).0"
else
  next="$old_major.$old_minor.$((old_patch + 1))"
fi

# 6. dist
if [[ -z $(find dist -type f 2> /dev/null | head -n 1) ]]; then
  fail "dist/ is empty - build first"
fi

date_str=${RELEASE_DATE:-$(date +%Y-%m-%d)}

# render_section: the changelog section for this release
render_section() {
  local title items item
  echo "## v$next - $date_str"
  echo
  for title in "Breaking changes:breaking" "Features:feats" "Fixes:fixes" "Other:other"; do
    local -n items=${title#*:}
    (( ${#items[@]} > 0 )) || continue
    echo "### ${title%%:*}"
    for item in "${items[@]}"; do echo "- $item"; done
    echo
  done
}

summary="${#breaking[@]} breaking, ${#feats[@]} features, ${#fixes[@]} fixes, ${#other[@]} other"

# 7. dry run
if (( dry )); then
  echo "would release $app v$next (was $old)"
  render_section
  exit 0
fi

# 8. artifacts
mkdir -p releases
tarball=releases/$app-$next.tar.gz
sums=releases/$app-$next.sums
tar -czf "$tarball" -C dist .
(
  cd dist
  find . -type f | sed 's|^\./||' | sort | while IFS= read -r f; do
    read -r crc size _ < <(cksum < "$f")
    echo "$crc $size $f"
  done
) > "$sums"

# 9. new changelog beside the old one
new_log=CHANGELOG.md.new
{
  printf '# Changelog\n\n'
  render_section
  if [[ -f CHANGELOG.md ]]; then tail -n +3 CHANGELOG.md; fi
} > "$new_log"

# 10. tag, the step that cannot be undone, comes last
if ! git tag -a "v$next" -m "$app $next" 2> /dev/null; then
  rm -f "$tarball" "$sums" "$new_log"
  echo "error: could not create tag v$next" >&2
  exit 5
fi
mv "$new_log" CHANGELOG.md

# 11. announce
if [[ -n $notify ]]; then
  body=$(printf '{"text":"%s v%s released: %s"}' "$app" "$next" "$summary")
  if ! curl -sS --fail --max-time 5 -X POST -H 'Content-Type: application/json' -d "$body" "$notify" > /dev/null 2>&1; then
    echo "warning: notification failed" >&2
    notify=
  fi
fi

echo "released $app v$next (was $old): $summary"
echo "artifact: $tarball"
[[ -z $notify ]] || echo "notified: $notify"
