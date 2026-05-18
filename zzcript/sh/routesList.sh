#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUTPUT_FILE="$ROOT_DIR/zzcript/output/routesContents.txt"
mkdir -p "$ROOT_DIR/zzcript/output"
rm -f "$OUTPUT_FILE"

echo "================================================================================" >> "$OUTPUT_FILE"
echo "GOVEMVC ROUTES REGISTRY EXPORT DUMP (/routes)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "This document contains a consolidated dump of all route registration files mapping" >> "$OUTPUT_FILE"
echo "HTTP verbs, URL paths, and advanced routing wildcards to Go controller handlers." >> "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

find "$ROOT_DIR/routes" -type f ! -path '*/.*' | sort | while read -r filepath; do
	relative_path="${filepath#$ROOT_DIR/}"
	echo "Adding: $relative_path"
	echo "================================================================================" >> "$OUTPUT_FILE"
	echo "FILE PATH: $relative_path"
	echo "================================================================================" >> "$OUTPUT_FILE"
	cat "$filepath" >> "$OUTPUT_FILE"
	echo "" >> "$OUTPUT_FILE"
	echo "" >> "$OUTPUT_FILE"
done
echo "Routes contents exported to zzcript/output/routesContents.txt"
