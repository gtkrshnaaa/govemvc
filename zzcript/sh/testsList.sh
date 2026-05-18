#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUTPUT_FILE="$ROOT_DIR/zzcript/output/testsContents.txt"
mkdir -p "$ROOT_DIR/zzcript/output"
rm -f "$OUTPUT_FILE"

echo "================================================================================" >> "$OUTPUT_FILE"
echo "GOVEMVC TESTING SUITES EXPORT DUMP (/tests)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "This document contains a consolidated dump of all automated unit and integration tests," >> "$OUTPUT_FILE"
echo "as well as the dynamic test automation runner scripts." >> "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

find "$ROOT_DIR/tests" -type f ! -path '*/.*' ! -path '*/tests/results/*' | sort | while read -r filepath; do
	relative_path="${filepath#$ROOT_DIR/}"
	echo "Adding: $relative_path"
	echo "================================================================================" >> "$OUTPUT_FILE"
	echo "FILE PATH: $relative_path"
	echo "================================================================================" >> "$OUTPUT_FILE"
	cat "$filepath" >> "$OUTPUT_FILE"
	echo "" >> "$OUTPUT_FILE"
	echo "" >> "$OUTPUT_FILE"
done
echo "Tests contents exported to zzcript/output/testsContents.txt"
