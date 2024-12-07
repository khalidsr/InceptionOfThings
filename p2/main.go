package main

import (
    "fmt"
    "net/http"
)

// handler function to respond to HTTP requests
func helloHandler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello, World!")
}

func main() {
    // Register the handler function with a specific route
    http.HandleFunc("/", helloHandler)

    // Start the server on port 8080
    fmt.Println("Starting server on :8080")
    if err := http.ListenAndServe(":8080", nil); err != nil {
        fmt.Println("Error starting server:", err)
    }
}

