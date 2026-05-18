#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUTPUT_FILE="$ROOT_DIR/zzcript/output/modelsContents.txt"
mkdir -p "$ROOT_DIR/zzcript/output"
rm -f "$OUTPUT_FILE"

echo "================================================================================" >> "$OUTPUT_FILE"
echo "GOVEMVC MODELS EXPORT DUMP (/models)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "This document contains a consolidated dump of all database models, entity definitions," >> "$OUTPUT_FILE"
echo "and raw SQL query mappings responsible for relational database transactions." >> "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

find "$ROOT_DIR/models" -type f ! -path '*/.*' | sort | while read -r filepath; do
	relative_path="${filepath#$ROOT_DIR/}"
	echo "Adding: $relative_path"
	echo "================================================================================" >> "$OUTPUT_FILE"
	echo "FILE PATH: $relative_path"
	echo "================================================================================" >> "$OUTPUT_FILE"
	cat "$filepath" >> "$OUTPUT_FILE"
	echo "" >> "$OUTPUT_FILE"
	echo "" >> "$OUTPUT_FILE"
done
echo "Models contents exported to zzcript/output/modelsContents.txt"
