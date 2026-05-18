package integration

import (
	"log"
	"net/http"
	"net/http/httptest"
	"net/url"
	"os"
	"strings"
	"testing"

	"govemvc/controllers"
	"govemvc/models"
	"govemvc/websocket"
)

func TestMain(m *testing.M) {
	// Change working directory to project root (2 levels up) so views/ can be resolved
	if err := os.Chdir("../.."); err != nil {
		log.Fatalf("failed to change directory to project root: %v", err)
	}

	// Start websocket active hub in a background Goroutine to prevent deadlocks on broadcasts
	go websocket.ActiveHub.Start()

	// Use official SQLite in-memory database as a mock database
	testDBPath := ":memory:"
	models.InitDB(testDBPath)

	code := m.Run()

	if models.DB != nil {
		models.DB.Close()
	}

	os.Exit(code)
}

func TestIndexHandler(t *testing.T) {
	req, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(controllers.IndexHandler)

	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v", status, http.StatusOK)
	}

	body := rr.Body.String()
	if !strings.Contains(body, "Todo List") {
		t.Errorf("rendered body does not contain 'Todo List'")
	}
}

func TestCreateTodoHandler(t *testing.T) {
	data := url.Values{}
	data.Set("title", "Integration Test Task")

	req, err := http.NewRequest("POST", "/todos", strings.NewReader(data.Encode()))
	if err != nil {
		t.Fatal(err)
	}
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(controllers.CreateTodoHandler)

	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusSeeOther {
		t.Errorf("handler returned wrong status code: got %v want %v", status, http.StatusSeeOther)
	}
}
