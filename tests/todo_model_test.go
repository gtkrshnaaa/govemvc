package tests

import (
	"log"
	"os"
	"testing"

	"govemvc/models"
)

func TestMain(m *testing.M) {
	// Change working directory to project root so templates in views/ can be resolved
	if err := os.Chdir(".."); err != nil {
		log.Fatalf("failed to change directory to project root: %v", err)
	}

	testDBPath := "test_govemvc.db"
	models.InitDB(testDBPath)

	code := m.Run()

	if models.DB != nil {
		models.DB.Close()
	}
	os.Remove(testDBPath)

	os.Exit(code)
}

func TestTodoCRUD(t *testing.T) {
	title := "Test Go Task"
	id, err := models.CreateTodo(title)
	if err != nil {
		t.Fatalf("failed to create todo: %v", err)
	}

	if id <= 0 {
		t.Errorf("expected positive ID, got %d", id)
	}

	todos, err := models.GetAllTodos()
	if err != nil {
		t.Fatalf("failed to get todos: %v", err)
	}

	found := false
	for _, todo := range todos {
		if todo.ID == id && todo.Title == title {
			found = true
			break
		}
	}

	if !found {
		t.Errorf("created todo with id %d and title '%s' not found in database", id, title)
	}

	err = models.ToggleTodo(id, true)
	if err != nil {
		t.Fatalf("failed to toggle todo status: %v", err)
	}

	todos, err = models.GetAllTodos()
	if err != nil {
		t.Fatalf("failed to get todos after update: %v", err)
	}

	for _, todo := range todos {
		if todo.ID == id {
			if !todo.Completed {
				t.Errorf("expected todo to be completed, got false")
			}
			break
		}
	}

	err = models.DeleteTodo(id)
	if err != nil {
		t.Fatalf("failed to delete todo: %v", err)
	}

	todos, err = models.GetAllTodos()
	if err != nil {
		t.Fatalf("failed to get todos after deletion: %v", err)
	}

	for _, todo := range todos {
		if todo.ID == id {
			t.Errorf("expected todo with id %d to be deleted, but it still exists", id)
		}
	}
}
