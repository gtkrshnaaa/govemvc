#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUTPUT_FILE="$ROOT_DIR/zzcript/output/viewsContents.txt"
mkdir -p "$ROOT_DIR/zzcript/output"
rm -f "$OUTPUT_FILE"

echo "================================================================================" >> "$OUTPUT_FILE"
echo "GOVEMVC VIEWS EXPORT DUMP (/views)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "This document contains a consolidated dump of all frontend UI assets, including HTML5" >> "$OUTPUT_FILE"
echo "templates, CSS stylesheets with premium glassmorphic/micro-animation rules, and vanilla" >> "$OUTPUT_FILE"
echo "Javascript WebSocket connection clients." >> "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

find "$ROOT_DIR/views" -type f ! -path '*/.*' | sort | while read -r filepath; do
	relative_path="${filepath#$ROOT_DIR/}"
	echo "Adding: $relative_path"
	echo "================================================================================" >> "$OUTPUT_FILE"
	echo "FILE PATH: $relative_path"
	echo "================================================================================" >> "$OUTPUT_FILE"
	cat "$filepath" >> "$OUTPUT_FILE"
	echo "" >> "$OUTPUT_FILE"
	echo "" >> "$OUTPUT_FILE"
done
echo "Views contents exported to zzcript/output/viewsContents.txt"
