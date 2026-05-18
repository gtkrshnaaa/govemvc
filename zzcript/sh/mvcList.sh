#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUTPUT_FILE="$ROOT_DIR/zzcript/output/mvcContents.txt"
mkdir -p "$ROOT_DIR/zzcript/output"
rm -f "$OUTPUT_FILE"

echo "================================================================================" >> "$OUTPUT_FILE"
echo "GOVEMVC MVC COMPONENT EXPORT DUMP (models, views, controllers)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "This document contains a consolidated dump of the core Model-View-Controller (MVC) layers." >> "$OUTPUT_FILE"
echo "It includes data representations/SQL operations (models), server-side rendering views/layouts/static assets," >> "$OUTPUT_FILE"
echo "and client request dispatch handlers (controllers)." >> "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

for folder in "models" "views" "controllers"; do
	find "$ROOT_DIR/$folder" -type f ! -path '*/.*' | sort | while read -r filepath; do
		relative_path="${filepath#$ROOT_DIR/}"
		echo "Adding: $relative_path"
		echo "================================================================================" >> "$OUTPUT_FILE"
		echo "FILE PATH: $relative_path"
		echo "================================================================================" >> "$OUTPUT_FILE"
		cat "$filepath" >> "$OUTPUT_FILE"
		echo "" >> "$OUTPUT_FILE"
		echo "" >> "$OUTPUT_FILE"
	done
done
echo "MVC contents exported to zzcript/output/mvcContents.txt"
