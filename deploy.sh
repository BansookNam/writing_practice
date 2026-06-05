#!/bin/bash
set -e

MSG=${1:-"update"}

git add -A
git commit -m "$MSG" || echo "Nothing to commit"
git push origin main

git push origin main:gh-pages

echo "Deployed to https://bansooknam.github.io/writing_practice/"
