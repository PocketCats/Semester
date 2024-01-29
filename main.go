package main

import (
	"github.com/ActiveBears/Semester/config"
	"github.com/ActiveBears/Semester/internal/infrastructure"
)

func main() {
	infrastructure.RunHttpServer(
		config.NewConfig(),
		infrastructure.NewRouter(),
		infrastructure.NewLogger(),
	)
}
