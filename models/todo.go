package models

import (
	"fmt"
)

// Todo represents a task item in the database.
type Todo struct {
	ID        int64  `json:"id"`
	Title     string `json:"title"`
	Completed bool   `json:"completed"`
}

// GetAllTodos retrieves all todo items from the database.
func GetAllTodos() ([]Todo, error) {
	rows, err := DB.Query("SELECT id, title, completed FROM todos ORDER BY id DESC")
	if err != nil {
		return nil, fmt.Errorf("failed to query todos: %w", err)
	}
	defer rows.Close()

	var todos []Todo
	for rows.Next() {
		var t Todo
		var compVal int
		if err := rows.Scan(&t.ID, &t.Title, &compVal); err != nil {
			return nil, fmt.Errorf("failed to scan todo row: %w", err)
		}
		t.Completed = compVal == 1
		todos = append(todos, t)
	}

	if err = rows.Err(); err != nil {
		return nil, fmt.Errorf("row iteration error: %w", err)
	}

	return todos, nil
}

// CreateTodo inserts a new todo item into the database.
func CreateTodo(title string) (int64, error) {
	result, err := DB.Exec("INSERT INTO todos (title, completed) VALUES (?, 0)", title)
	if err != nil {
		return 0, fmt.Errorf("failed to insert todo: %w", err)
	}

	id, err := result.LastInsertId()
	if err != nil {
		return 0, fmt.Errorf("failed to get last inserted id: %w", err)
	}

	return id, nil
}

// ToggleTodo updates the completion status of a todo item.
func ToggleTodo(id int64, completed bool) error {
	compVal := 0
	if completed {
		compVal = 1
	}

	_, err := DB.Exec("UPDATE todos SET completed = ? WHERE id = ?", compVal, id)
	if err != nil {
		return fmt.Errorf("failed to update todo: %w", err)
	}

	return nil
}

// DeleteTodo removes a todo item from the database.
func DeleteTodo(id int64) error {
	_, err := DB.Exec("DELETE FROM todos WHERE id = ?", id)
	if err != nil {
		return fmt.Errorf("failed to delete todo: %w", err)
	}

	return nil
}
