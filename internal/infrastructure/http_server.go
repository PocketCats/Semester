package infrastructure

import (
	"bytes"
	"errors"
	"fmt"
	"github.com/ActiveBears/Semester/config"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"log"
	"net/http"
	"os"
	"time"
)

func RunHttpServer(conf config.Config, handler http.Handler, lg *log.Logger) {
	addr := fmt.Sprintf(
		"%s:%s",
		conf.Server.HttpHost,
		conf.Server.HttpPort,
	)

	srv := http.Server{
		Addr:    addr,
		Handler: handler,
	}

	lg.Printf("Starting server %s", addr)
	if err := srv.ListenAndServe(); err != nil || !errors.Is(err, http.ErrServerClosed) {
		lg.Fatalln(err)
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
		bytes.NewBufferString("Hello, world!").WriteTo(w)
	})

	return router
}

func NewLogger() *log.Logger {
	return log.New(
		os.Stdout,
		"[semester]: ",
		log.Ldate|log.Ltime|log.Lshortfile,
	)
}
