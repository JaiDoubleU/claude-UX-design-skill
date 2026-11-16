#!/usr/bin/env bash
# Create a fresh eval project from evals/scaffold, ready for a blind agent to build a page in.
# Usage: evals/scripts/new-run.sh <destination-dir>
# The destination must not exist. Prints the project path when done.
set -euo pipefail

dest="${1:?usage: new-run.sh <destination-dir>}"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo="$(cd "$here/../.." && pwd)"
scaffold="$repo/evals/scaffold"
tokens="$repo/skills/enverus-ux-design-skill/references/enverus-one/tokens.css"

[ -e "$dest" ] && { echo "error: $dest already exists" >&2; exit 1; }
[ -f "$tokens" ] || { echo "error: tokens.css not found at $tokens" >&2; exit 1; }

mkdir -p "$dest"
# Copy everything except installed or built output.
(cd "$scaffold" && tar --exclude=node_modules --exclude=dist -cf - .) | (cd "$dest" && tar -xf -)
# Take tokens.css from the skill so the run always uses the current source of truth.
cp "$tokens" "$dest/src/tokens.css"

(cd "$dest" && npm ci --prefer-offline --no-audit --no-fund >/dev/null)
echo "$dest"
