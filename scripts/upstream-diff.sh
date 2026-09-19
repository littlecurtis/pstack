#!/usr/bin/env bash
# For every Layer 2 file with a `derived-from: <path> @ <sha>` header, show what
# upstream changed in <path> since <sha>. Run after `git fetch upstream`.
#
#   scripts/upstream-diff.sh          # summary: one line per derived file
#   scripts/upstream-diff.sh --patch  # full diffs
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

mode="${1:-summary}"
found=0

while IFS= read -r file; do
	header=$(grep -m1 -oE 'derived-from: *[^ ]+ *@ *[0-9a-f]+' "$file" || true)
	[ -z "$header" ] && continue
	src=$(sed -E 's/derived-from: *([^ ]+) *@ *([0-9a-f]+)/\1/' <<<"$header")
	sha=$(sed -E 's/derived-from: *([^ ]+) *@ *([0-9a-f]+)/\2/' <<<"$header")
	found=1

	if ! git cat-file -e "$sha" 2>/dev/null; then
		printf '%-50s  ?  unknown sha %s\n' "$file" "$sha"
		continue
	fi
	if ! git cat-file -e "upstream/main:$src" 2>/dev/null; then
		printf '%-50s  !  %s no longer exists upstream\n' "$file" "$src"
		continue
	fi

	changes=$(git diff --shortstat "$sha" upstream/main -- "$src")
	if [ -z "$changes" ]; then
		printf '%-50s  =  %s unchanged since %s\n' "$file" "$src" "$sha"
	else
		printf '%-50s  ~  %s:%s\n' "$file" "$src" "$changes"
		[ "$mode" = "--patch" ] && git diff "$sha" upstream/main -- "$src"
	fi
done < <(git ls-files -co --exclude-standard 'skills/*/SKILL.md' 'agents/*.md')

[ "$found" = 0 ] && echo "no derived-from headers found"
exit 0
