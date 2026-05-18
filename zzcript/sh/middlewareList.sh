#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUTPUT_FILE="$ROOT_DIR/zzcript/output/middlewareContents.txt"
mkdir -p "$ROOT_DIR/zzcript/output"
rm -f "$OUTPUT_FILE"

echo "================================================================================" >> "$OUTPUT_FILE"
echo "GOVEMVC MIDDLEWARE EXPORT DUMP (/middleware)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "This document contains a consolidated dump of all global HTTP middleware components," >> "$OUTPUT_FILE"
echo "focusing on security headers, request instrumentation/logging, and active crash recovery" >> "$OUTPUT_FILE"
echo "pipelines." >> "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

find "$ROOT_DIR/middleware" -type f ! -path '*/.*' | sort | while read -r filepath; do
	relative_path="${filepath#$ROOT_DIR/}"
	echo "Adding: $relative_path"
	echo "================================================================================" >> "$OUTPUT_FILE"
	echo "FILE PATH: $relative_path"
	echo "================================================================================" >> "$OUTPUT_FILE"
	cat "$filepath" >> "$OUTPUT_FILE"
	echo "" >> "$OUTPUT_FILE"
	echo "" >> "$OUTPUT_FILE"
done
echo "Middleware contents exported to zzcript/output/middlewareContents.txt"
