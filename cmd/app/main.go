package main

import (
	"log"
	"net/http"
	"os"

	"govemvc/models"
	"govemvc/routes"
	"govemvc/websocket"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	dbPath := os.Getenv("DB_PATH")
	if dbPath == "" {
		dbPath = "database/govemvc.db"
	}

	log.Printf("initializing database at %s...", dbPath)
	models.InitDB(dbPath)

	log.Println("starting websocket active hub...")
	go websocket.ActiveHub.Start()

	router := routes.RegisterRoutes()

	addr := ":" + port
	log.Printf("server is starting and listening on http://localhost%s", addr)
	if err := http.ListenAndServe(addr, router); err != nil {
		log.Fatalf("failed to start server: %v", err)
	}
}
