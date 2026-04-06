#!/usr/bin/env bash
## assemble-team.sh — combine team front matter + per-member Summary/Expertise
## Usage: assemble-team.sh <output.md> <team.md> <member1.md> [member2.md ...]
##
## Produces a single markdown file: team YAML front matter + intro body
## from team.md, followed by one accentcard block per member.

set -euo pipefail

OUT="$1"; shift
TEAM_MD="$1"; shift
MEMBERS=("$@")

# Extract YAML front matter from team.md (between --- delimiters)
FRONT_MATTER=$(awk '/^---/{found++; if(found==2){exit}} found{print}' "$TEAM_MD")

# Extract body (after second --- delimiter) from team.md
TEAM_BODY=$(awk 'found{print} /^---/{found++; if(found==2){found=3}}' "$TEAM_MD")

{
  echo "---"
  echo "$FRONT_MATTER"
  echo "---"
  echo ""
  echo "$TEAM_BODY"
  echo ""
} > "$OUT"

# For each member: extract name, role, tagline from front matter,
# then extract Summary and Expertise sections.
for MD in "${MEMBERS[@]}"; do
  NAME=$(awk -F'"' '/^name:/{print $2}' "$MD")
  ROLE=$(awk -F'"' '/^role:/{print $2}' "$MD")
  TAGLINE=$(awk -F'"' '/^tagline:/{print $2}' "$MD")

  # Extract ## Summary section (up to next ## or EOF)
  SUMMARY=$(awk '/^## Summary/{found=1; next} found && /^## /{exit} found{print}' "$MD" | sed '/^[[:space:]]*$/d' | head -5)

  # Extract ## Expertise bullets (up to next ## or EOF)
  EXPERTISE=$(awk '/^## Expertise/{found=1; next} found && /^## /{exit} found{print}' "$MD" | grep '^-' | head -4)

  {
    echo ""
    echo "\\begin{accentcard}"
    echo "**${NAME}** — *${ROLE}*"
    echo ""
    echo "${TAGLINE}"
    echo ""
    echo "${SUMMARY}"
    echo ""
    echo "${EXPERTISE}"
    echo "\\end{accentcard}"
    echo ""
  } >> "$OUT"
done
