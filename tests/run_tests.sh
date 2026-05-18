#!/bin/bash

# GOVEMVC Test Runner & Result Aggregator
# Automates test execution and compiles test results/coverage reports into tests/results/

set -e

# Resolve directory paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== GOVEMVC TEST RUNNER ==="
echo "Project Root: $ROOT_DIR"
echo "Cleaning old test results..."
rm -f "$SCRIPT_DIR/results/coverage.out"
rm -f "$SCRIPT_DIR/results/coverage.html"
rm -f "$SCRIPT_DIR/results/test-report.log"

echo "Running unit and integration tests..."
# Run tests and pipe verbose output to log file
go test -v -coverpkg=govemvc/models,govemvc/controllers,govemvc/websocket "$ROOT_DIR/tests/unit" "$ROOT_DIR/tests/integration" -coverprofile="$SCRIPT_DIR/results/coverage.out" > "$SCRIPT_DIR/results/test-report.log" 2>&1 || true

# Validate test outputs
if grep -q "FAIL" "$SCRIPT_DIR/results/test-report.log"; then
    echo "Some tests failed! Review details in: tests/results/test-report.log"
    exit 1
else
    echo "All tests passed successfully!"
fi

echo "Generating HTML coverage report..."
go tool cover -html="$SCRIPT_DIR/results/coverage.out" -o "$SCRIPT_DIR/results/coverage.html"

echo "Reports successfully gathered under tests/results/:"
echo "  - Log Output: tests/results/test-report.log"
echo "  - Coverage Profile: tests/results/coverage.out"
echo "  - HTML Coverage Map: tests/results/coverage.html"
echo "=============================="
