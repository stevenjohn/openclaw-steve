#!/bin/bash
# archive-memory.sh — Move daily memory files older than 7 days to memory/archive/
# Safe to run anytime. Called by weekly cron.

WORKSPACE="/home/steve/.openclaw/workspace"
MEMORY_DIR="$WORKSPACE/memory"
ARCHIVE_DIR="$MEMORY_DIR/archive"

mkdir -p "$ARCHIVE_DIR"

ARCHIVED=0
while IFS= read -r -d '' file; do
  filename=$(basename "$file")
  mv "$file" "$ARCHIVE_DIR/$filename"
  echo "Archived: $filename"
  ARCHIVED=$((ARCHIVED + 1))
done < <(find "$MEMORY_DIR" -maxdepth 1 -name "20[0-9][0-9]-[0-9][0-9]-[0-9][0-9].md" -mtime +7 -print0)

echo "Done. $ARCHIVED file(s) archived."
