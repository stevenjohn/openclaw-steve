#!/bin/bash
# auto-commit.sh — Commit and push tracked workspace changes
# Usage: ./scripts/auto-commit.sh "commit message"
# Called by agent after any skill/agent file updates

WORKSPACE="/home/steve/.openclaw/workspace"
MSG="${1:-"Auto-update: agent file changes"}"

cd "$WORKSPACE" || exit 1

# Only commit if there are tracked changes
if git diff --quiet && git diff --cached --quiet; then
  echo "Nothing to commit."
  exit 0
fi

git add -A
git commit -m "$MSG"
git push origin master && echo "✅ Pushed: $MSG" || echo "❌ Push failed"
