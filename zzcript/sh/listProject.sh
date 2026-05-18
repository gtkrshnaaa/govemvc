#!/bin/bash

# GOVEMVC Source Code Exporter & Architectural Lister
# Consolidates source code into structured text files under zzcript/output/ with premium technical descriptions

set -e

# Resolve paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUTPUT_DIR="$ROOT_DIR/zzcript/output"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# List of valid project folders
declare -A FOLDER_DESC
FOLDER_DESC["cmd"]="Core Entry Points: Boots the web application server and unified CLI database administrator tools"
FOLDER_DESC["controllers"]="HTTP Handlers (Controllers): Manages application logic, request/response cycles, and coordinate templates"
FOLDER_DESC["database"]="Database Layer: Handles versioned SQL migrations and seeder scripts for relational persistence"
FOLDER_DESC["middleware"]="Security & Pipelines (Middleware): Implements security headers, request logging, and panic capture layers"
FOLDER_DESC["models"]="Data Access Layer: Defines data entities, business models, and executes raw parameterized SQL queries"
FOLDER_DESC["routes"]="Route Registry: Maps standard HTTP request methods and URL wildcards to the appropriate controllers"
FOLDER_DESC["tests"]="Quality Assurance & Testing: Houses automated unit/integration suites and visual HTML coverage report pipelines"
FOLDER_DESC["views"]="Frontend UI (Views): Contains HTML5 template documents, vanilla Javascript websocket bindings, and styling"
FOLDER_DESC["websocket"]="Real-time Communication Layer: Implements high-performance low-level HTTP hijack protocols and state broadcast hub"

echo "=== GOVEMVC PROJECT DUMPER & LISTER ==="
echo "Select the scope of file contents to export:"
echo "1) Entire Project (all source files)"
echo "2) Specific Directory"
read -p "Enter choice (1 or 2): " MAIN_CHOICE

SELECTED_FOLDER=""
OUTPUT_FILE=""
DESCRIPTION=""

if [ "$MAIN_CHOICE" == "1" ]; then
	SELECTED_FOLDER="all"
	OUTPUT_FILE="$OUTPUT_DIR/allProjectContents.txt"
	DESCRIPTION="GOVEMVC ALL SOURCE CODE EXPORT DUMP

This document contains a comprehensive, consolidated dump of all source code files
comprising the GOVEMVC project. It includes core boot handlers, MVC layers, databases,
real-time WebSocket protocols, and isolated unit/integration testing suites.

Utilize this consolidated text to review the entire application architecture, perform
full-system audits, or transport code cleanly across sandboxed development hosts."
else
	echo "Available folders to export:"
	KEYS=("cmd" "controllers" "database" "middleware" "models" "routes" "tests" "views" "websocket")
	for i in "${!KEYS[@]}"; do
		echo "$((i+1))) ${KEYS[$i]} (${FOLDER_DESC[${KEYS[$i]}]})"
	done
	read -p "Select folder number (1-9): " FOLDER_NUM
	
	if ! [[ "$FOLDER_NUM" =~ ^[1-9]$ ]]; then
		echo "Invalid selection. Exiting."
		exit 1
	fi
	
	INDEX=$((FOLDER_NUM-1))
	SELECTED_FOLDER="${KEYS[$INDEX]}"
	OUTPUT_FILE="$OUTPUT_DIR/${SELECTED_FOLDER}FolderContents.txt"
	DESCRIPTION="GOVEMVC TARGETED MODULE EXPORT: /${SELECTED_FOLDER}

This document contains a consolidated dump of all source code files under the /${SELECTED_FOLDER}
directory of the GOVEMVC project.

Module Focus: ${FOLDER_DESC[$SELECTED_FOLDER]}

Utilize this targeted text dump to review the specific layer's implementation, perform modular
audits, or troubleshoot business-logic flows in isolation."
fi

# Clean previous output
rm -f "$OUTPUT_FILE"

# Generate File Header and Description
echo "================================================================================" >> "$OUTPUT_FILE"
echo "$DESCRIPTION" >> "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Locate and dump files
echo "Exporting files, please wait..."

if [ "$SELECTED_FOLDER" == "all" ]; then
	# Search entire project root except ignored folders/files
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
else
	# Search specific folder
	find "$ROOT_DIR/$SELECTED_FOLDER" -type f \
		! -path '*/.*' \
		! -path '*/tests/results/*' \
		! -name '*.db' \
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
fi

echo "Export completed successfully!"
echo "Output saved to: zzcript/output/$(basename "$OUTPUT_FILE")"
