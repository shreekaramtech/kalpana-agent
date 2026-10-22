#!/bin/sh
# skills/ at the root is the source. Each plugin carries a copy of its own
# skill, because the Claude directory and the ChatGPT portal read a plugin
# folder on its own. Run this after editing a skill; CI fails when they differ.
set -eu
cd "$(dirname "$0")/.."

copy() {
	rm -rf "plugins/$1/skills/$2"
	mkdir -p "plugins/$1/skills"
	cp -R "skills/$2" "plugins/$1/skills/$2"
}

copy kalpana-batch create-creative-batch
copy kalpana-designer design-a-template
