#!/usr/bin/env bash
# Build VitePress and force-push docs/.vitepress/dist to the gh-pages branch.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
npm ci
npm run docs:build
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
cp -a docs/.vitepress/dist/. "$TMP/"
touch "$TMP/.nojekyll"
cd "$TMP"
git init -b gh-pages
git add -A
git -c user.name="${GIT_AUTHOR_NAME:-gradient30}" \
    -c user.email="${GIT_AUTHOR_EMAIL:-gradient30@users.noreply.github.com}" \
    commit -m "Deploy VitePress site to GitHub Pages"
git remote add origin "https://github.com/gradient30/wezterm-handbook-zh.git"
git push -u origin gh-pages --force
echo "Deployed. Site: https://gradient30.github.io/wezterm-handbook-zh/"
