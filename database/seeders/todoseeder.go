package seeders

import (
	"fmt"
	"govemvc/models"
)

// SeedTodos populates the todos table with initial sample data.
func SeedTodos() error {
	samples := []string{
		"Learn Golang Standard Library",
		"Design GOVEMVC Standard Convention",
		"Build reactive real-time Todo App",
		"Deploy with Multi-stage Docker container",
	}

	for _, title := range samples {
		_, err := models.CreateTodo(title)
		if err != nil {
			return fmt.Errorf("failed to seed todo '%s': %w", title, err)
		}
	}
	return nil
}
