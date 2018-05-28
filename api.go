package main

import (
	"fmt"
	"io"
	"net/http"
)

func hello(w http.ResponseWriter, r *http.Request) {
	// Default response
	res := "Hello World!"

	// Check for a name parameter in querystring
	queryVals := r.URL.Query()
	name := queryVals.Get("name")
	if name != "" {
		res = fmt.Sprintf("Hello %s!", name)
	}

	// Write response
	io.WriteString(w, res)
}

func health(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "Ok")
}

func main() {
	// Create http handler mux
	mux := http.NewServeMux()

	// Set health and hello world routes
	mux.HandleFunc("/", health)
	mux.HandleFunc("/hello", hello)

	// Start listening
	fmt.Println("Sample API server listening on 127.0.0.1:8080")
	http.ListenAndServe("127.0.0.1:8080", mux)
}
