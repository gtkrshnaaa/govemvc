#!/bin/bash

# GOVEMVC Test Runner & Result Aggregator
# Automates test execution and compiles test results/coverage reports into tests/results/

set -e

# Resolve directory paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Define cleanup trap to ensure files are ALWAYS restored to underscore-free camelCase
restoreNames() {
	mv -f "$SCRIPT_DIR/unit/todoModel_test.go" "$SCRIPT_DIR/unit/todoModelTest.go" 2>/dev/null || true
	mv -f "$SCRIPT_DIR/integration/todoController_test.go" "$SCRIPT_DIR/integration/todoControllerTest.go" 2>/dev/null || true
}
trap restoreNames EXIT

echo "=== GOVEMVC TEST RUNNER ==="
echo "Project Root: $ROOT_DIR"
echo "Cleaning old test results..."
rm -f "$SCRIPT_DIR/results/coverage.out"
rm -f "$SCRIPT_DIR/results/coverage.html"
rm -f "$SCRIPT_DIR/results/testReport.log"

echo "Preparing test files for Go toolchain compilation..."
# Dynamically rename test files to follow Go compiler's strict suffix requirement
mv "$SCRIPT_DIR/unit/todoModelTest.go" "$SCRIPT_DIR/unit/todoModel_test.go"
mv "$SCRIPT_DIR/integration/todoControllerTest.go" "$SCRIPT_DIR/integration/todoController_test.go"

echo "Running unit and integration tests..."
# Run tests and pipe verbose output to log file
go test -v -coverpkg=govemvc/models,govemvc/controllers,govemvc/websocket "$ROOT_DIR/tests/unit" "$ROOT_DIR/tests/integration" -coverprofile="$SCRIPT_DIR/results/coverage.out" > "$SCRIPT_DIR/results/testReport.log" 2>&1 || true

# Restore names immediately after go test is finished
restoreNames

# Validate test outputs
if grep -q "FAIL" "$SCRIPT_DIR/results/testReport.log"; then
    echo "Some tests failed! Review details in: tests/results/testReport.log"
    exit 1
else
    echo "All tests passed successfully!"
fi

echo "Generating HTML coverage report..."
go tool cover -html="$SCRIPT_DIR/results/coverage.out" -o "$SCRIPT_DIR/results/coverage.html"

echo "Reports successfully gathered under tests/results/:"
echo "  - Log Output: tests/results/testReport.log"
echo "  - Coverage Profile: tests/results/coverage.out"
echo "  - HTML Coverage Map: tests/results/coverage.html"
echo "=============================="
