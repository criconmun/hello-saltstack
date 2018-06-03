package main

import (
	"bytes"
	"fmt"
	"github.com/gorilla/mux"
	"github.com/spf13/viper"
	"io"
	"io/ioutil"
	"net/http"
)

var version = "v1.0"

func getIndex(w http.ResponseWriter, r *http.Request) {
	message := "Sending stuff to you: "
	message = message + version
	io.WriteString(w, message)
}

func postIndex(w http.ResponseWriter, r *http.Request) {
	message := "Receiving stuff from you: "
	message = message + version
	io.WriteString(w, message)
}

func main() {

	// Read config file
	yamlFile, err := ioutil.ReadFile("/etc/hello-saltstack/config.yaml")
	if err != nil {
		fmt.Println("Could not load config file, sticking with defaults")
	}
	// Set defaults
	viper.SetDefault("port", "8080")
	// Parse config file
	viper.SetConfigType("yaml")
	viper.ReadConfig(bytes.NewBuffer(yamlFile))
	port := viper.GetString("port")

	// Setup webserver
	router := mux.NewRouter()
	router.HandleFunc("/", getIndex).Methods("GET")
	router.HandleFunc("/", postIndex).Methods("POST")
	if err := http.ListenAndServe(":"+port, router); err != nil {
		panic(err)
	}

}
