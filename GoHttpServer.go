package main
import (
    "net/http"
    "os"
)
func indexHandler(w http.ResponseWriter, r *http.Request) {
    w.Write([]byte("<h1>Hello-World-3!</h1>"))
}
func main() {
    port := os.Getenv("PORT")
    if port == "" {
        port = "80"
    }
    mux := http.NewServeMux()
    mux.HandleFunc("/", indexHandler)
    http.ListenAndServe(":"+port, mux)
}

