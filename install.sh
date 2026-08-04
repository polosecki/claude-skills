#!/usr/bin/env bash
# Install this repo's Claude Code skills into the personal skills directory.
#
#   ./install.sh          copy   (default; re-run after a git pull to pick up changes)
#   ./install.sh --link   symlink (a git pull updates the skills in place)
#   ./install.sh --check  report what is installed and whether it matches this repo
#
# Skills are discovered at ~/.claude/skills/<name>/SKILL.md. Restart Claude Code after
# installing — the skill list is read at session start, not on demand.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
MODE="copy"
case "${1:-}" in
  --link)  MODE="link" ;;
  --check) MODE="check" ;;
  --help|-h) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  "") ;;
  *) echo "unknown option: $1 (try --help)" >&2; exit 2 ;;
esac

skills=()
for d in "$SRC"/*/; do
  [ -f "$d/SKILL.md" ] && skills+=("$(basename "$d")")
done
if [ ${#skills[@]} -eq 0 ]; then echo "no skills found in $SRC" >&2; exit 1; fi

if [ "$MODE" = "check" ]; then
  status=0
  for s in "${skills[@]}"; do
    printf '  %-16s ' "$s"
    if [ ! -e "$DEST/$s/SKILL.md" ]; then echo "NOT INSTALLED"; status=1
    elif [ -L "$DEST/$s" ]; then echo "linked -> $(readlink "$DEST/$s")"
    elif cmp -s "$SRC/$s/SKILL.md" "$DEST/$s/SKILL.md"; then echo "copied, matches this repo"
    else echo "copied, DIFFERS from this repo"; status=1
    fi
  done
  exit $status
fi

mkdir -p "$DEST"
# Backups go OUTSIDE $DEST. Claude Code discovers a skill at <skills dir>/<name>/SKILL.md, so a
# backup kept as a sibling — skills/foo.backup.20260804/SKILL.md — is itself a valid skill path and
# registers as a second, stale copy of the skill it was meant to protect. Same directory, wrong
# namespace. Keeping the safety net, moving it out of the search path.
BACKUPS="${CLAUDE_SKILL_BACKUPS:-$(dirname "$DEST")/skill-backups}"
for s in "${skills[@]}"; do
  target="$DEST/$s"
  # Back up anything already there that is not ours, so a local edit is never lost silently.
  if [ -e "$target" ] && [ ! -L "$target" ] && ! cmp -s "$SRC/$s/SKILL.md" "$target/SKILL.md" 2>/dev/null; then
    mkdir -p "$BACKUPS"
    backup="$BACKUPS/$s.$(date +%Y%m%d%H%M%S)"
    mv "$target" "$backup"
    echo "  existing $s differed — kept at $backup"
  fi
  rm -rf "$target"
  if [ "$MODE" = "link" ]; then ln -sfn "$SRC/$s" "$target"; echo "  linked  $s"
  else cp -R "$SRC/$s" "$target"; echo "  copied  $s"; fi
done

echo
echo "Installed ${#skills[@]} skill(s) into $DEST"
echo "Restart Claude Code, then check with:  /help  or ask it to list available skills."
