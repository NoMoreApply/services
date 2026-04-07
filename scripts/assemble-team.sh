#!/usr/bin/env bash
## assemble-team.sh — combine team front matter + per-member Summary/Expertise
## Usage: assemble-team.sh <output.md> <team.md> <member1.md> [member2.md ...]

set -euo pipefail

OUT="$1"; shift
TEAM_MD="$1"; shift
MEMBERS=("$@")

# Strip em dashes from a string, replace with plain hyphen
strip_emdash() {
  echo "$1" | sed 's/ — / - /g; s/—/-/g'
}

# Front matter: lines between first and second --- (exclusive of both)
FRONT_MATTER=$(awk 'NR==1{next} /^---/{exit} {print}' "$TEAM_MD")

# Body: everything after the second ---
TEAM_BODY=$(awk 'BEGIN{n=0} /^---/{n++; next} n>=2{print}' "$TEAM_MD" | sed 's/ — / - /g; s/—/-/g')

{
  echo "---"
  echo "$FRONT_MATTER"
  echo "---"
  echo ""
  echo "$TEAM_BODY"
  echo ""
} > "$OUT"

for MD in "${MEMBERS[@]}"; do
  NAME=$(awk -F'"' '/^name:/{print $2}' "$MD")
  ROLE=$(strip_emdash "$(awk -F'"' '/^role:/{print $2}' "$MD")")
  TAGLINE=$(strip_emdash "$(awk -F'"' '/^tagline:/{print $2}' "$MD")")

  SUMMARY=$(awk '/^## Summary/{found=1; next} found && /^## /{exit} found && NF{print}' "$MD" | head -4 | sed 's/ — / - /g; s/—/-/g')

  # Expertise as Typst list items (one per line, indented)
  EXPERTISE_ITEMS=$(awk '/^## Expertise/{found=1; next} found && /^## /{exit} found && /^-/{print}' "$MD" | head -4 | sed 's/^- //; s/ — / - /g; s/—/-/g')

  # Build Typst list block
  TYPST_LIST=""
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    TYPST_LIST="${TYPST_LIST}  - ${line}"$'\n'
  done <<< "$EXPERTISE_ITEMS"

  {
    printf '```{=typst}\n'
    echo "#v(0.6em)"
    echo "#accentcard(["
    echo "  #text(size: 13pt, weight: \"bold\")[${NAME}]"
    echo "  #linebreak()"
    echo "  #text(size: 10pt, fill: midgrey)[${ROLE}]"
    echo "  #linebreak()"
    echo "  #text(size: 9.5pt, style: \"italic\", fill: midgrey)[${TAGLINE}]"
    echo "  #v(0.4em)"
    echo "  ${SUMMARY}"
    echo "  #v(0.3em)"
    printf '%s' "$TYPST_LIST"
    echo "])"
    printf '```\n'
    echo ""
  } >> "$OUT"
done
