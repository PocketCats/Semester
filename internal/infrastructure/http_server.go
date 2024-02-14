package infrastructure

import (
	"errors"
	"fmt"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"log"
	"net/http"
	"os"
	"time"
)

func RunHttpServer(lg *log.Logger, handler http.Handler) {
	srv := http.Server{
		Addr:    ":80",
		Handler: handler,
	}

	if err := srv.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
		lg.Fatalf("Server shutdown without grace: %s", err)
	}
}

func NewRouter() http.Handler {
	router := chi.NewRouter()
	router.Use(
		middleware.Logger,
		middleware.RealIP,
		middleware.RequestID,
		middleware.Recoverer,
		middleware.CleanPath,
		middleware.StripSlashes,
		middleware.Heartbeat("/hc"),
		middleware.SupressNotFound(router),
		middleware.Timeout(time.Second*5),
	)

	router.Get("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, "Hello, world!")
	})

	return router
}

func NewLogger() *log.Logger {
	return log.New(os.Stdout, "[semester]::", log.Ldate|log.Ltime|log.Lshortfile)
}
