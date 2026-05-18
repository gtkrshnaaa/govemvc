#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUTPUT_FILE="$ROOT_DIR/zzcript/output/coreContents.txt"
mkdir -p "$ROOT_DIR/zzcript/output"
rm -f "$OUTPUT_FILE"

echo "================================================================================" >> "$OUTPUT_FILE"
echo "GOVEMVC BACKEND CORE EXPORT DUMP (No Frontend/Views Included)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "This document contains a consolidated dump of all backend source code files of the GOVEMVC" >> "$OUTPUT_FILE"
echo "project (excluding frontend layout templates, HTML pages, and static UI assets)." >> "$OUTPUT_FILE"
echo "It includes the entrypoint web boot, controllers, database administration, custom middleware," >> "$OUTPUT_FILE"
echo "model structures, routes mapping, WebSocket hijack hub, and automated tests." >> "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

for folder in "cmd" "controllers" "database" "middleware" "models" "routes" "tests" "websocket"; do
	find "$ROOT_DIR/$folder" -type f ! -path '*/.*' ! -path '*/tests/results/*' ! -name '*.db' | sort | while read -r filepath; do
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
echo "Core backend contents exported to zzcript/output/coreContents.txt"
