package main

import (
	"github.com/gorilla/mux"
	"io"
	"net/http"
)

func getIndex(w http.ResponseWriter, r *http.Request) {
	message := "Sending stuff to you..."
	io.WriteString(w, message)
}

func postIndex(w http.ResponseWriter, r *http.Request) {
	message := "Receiving stuff from you..."
	io.WriteString(w, message)
}

func main() {
	router := mux.NewRouter()

	router.HandleFunc("/", getIndex).Methods("GET")
	router.HandleFunc("/", postIndex).Methods("POST")

	if err := http.ListenAndServe(":8080", router); err != nil {
		panic(err)
	}

}
