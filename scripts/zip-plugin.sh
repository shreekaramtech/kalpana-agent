#!/bin/sh
# Builds the ChatGPT / Codex submission ZIP for one plugin folder:
#   ./scripts/zip-plugin.sh kalpana-batch   -> dist/kalpana-batch.zip
# The ZIP holds the portable plugin.json and mcp.json, skills/ and assets/.
# Never add an .app.json: ZIPs with app references cannot be submitted.
set -eu
cd "$(dirname "$0")/.."
name="${1:?plugin folder name, e.g. kalpana-batch}"
[ -d "plugins/$name" ] || { echo "no plugins/$name" >&2; exit 1; }
./scripts/sync-skills.sh
mkdir -p dist
rm -f "dist/$name.zip"
(cd "plugins/$name" && zip -qr "../../dist/$name.zip" plugin.json mcp.json skills assets -x '.DS_Store')
echo "dist/$name.zip"
