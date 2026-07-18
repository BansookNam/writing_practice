#!/bin/bash
set -e

MSG=${1:-"update"}

# ── Bump version in index.html (patch → minor → major, max 99 each) ──
CUR=$(grep -oE '<span class="version">v[0-9]+\.[0-9]+\.[0-9]+</span>' index.html | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')

if [ -z "$CUR" ]; then
  echo "Could not find version in index.html; skipping bump"
else
  MAJOR=${CUR%%.*}
  REST=${CUR#*.}
  MINOR=${REST%%.*}
  PATCH=${REST#*.}

  PATCH=$((PATCH + 1))
  if [ "$PATCH" -gt 99 ]; then
    PATCH=0
    MINOR=$((MINOR + 1))
    if [ "$MINOR" -gt 99 ]; then
      MINOR=0
      MAJOR=$((MAJOR + 1))
    fi
  fi

  NEW="$MAJOR.$MINOR.$PATCH"
  sed -i '' -E "s#<span class=\"version\">v[0-9]+\.[0-9]+\.[0-9]+</span>#<span class=\"version\">v$NEW</span>#" index.html
  echo "Bumped version: $CUR → $NEW"
fi

git add -A
git commit -m "$MSG" || echo "Nothing to commit"
git push origin main

git push origin main:gh-pages

echo "Deployed to https://bansooknam.github.io/writing_practice/"
