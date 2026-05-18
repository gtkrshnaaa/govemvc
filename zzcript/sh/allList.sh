#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUTPUT_FILE="$ROOT_DIR/zzcript/output/allContents.txt"
mkdir -p "$ROOT_DIR/zzcript/output"
rm -f "$OUTPUT_FILE"

echo "================================================================================" >> "$OUTPUT_FILE"
echo "GOVEMVC ALL SOURCE CODE EXPORT DUMP" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "This document contains a comprehensive, consolidated dump of all source code files" >> "$OUTPUT_FILE"
echo "comprising the GOVEMVC project. It includes core boot handlers, MVC layers, databases," >> "$OUTPUT_FILE"
echo "real-time WebSocket protocols, and isolated unit/integration testing suites." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "Utilize this consolidated text to review the entire application architecture, perform" >> "$OUTPUT_FILE"
echo "full-system audits, or transport code cleanly across sandboxed development hosts." >> "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

find "$ROOT_DIR" -type f \
	! -path '*/.*' \
	! -path '*/node_modules/*' \
	! -path '*/zzcript/*' \
	! -path '*/tests/results/*' \
	! -name '*.db' \
	! -name 'main' \
	! -name 'Dockerfile' \
	! -name 'docker-compose.yml' \
	! -name 'go.sum' \
	| sort | while read -r filepath; do
		relative_path="${filepath#$ROOT_DIR/}"
		echo "Adding: $relative_path"
		echo "================================================================================" >> "$OUTPUT_FILE"
		echo "FILE PATH: $relative_path"
		echo "================================================================================" >> "$OUTPUT_FILE"
		cat "$filepath" >> "$OUTPUT_FILE"
		echo "" >> "$OUTPUT_FILE"
		echo "" >> "$OUTPUT_FILE"
	done
echo "All contents exported to zzcript/output/allContents.txt"
