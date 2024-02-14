package main

import "github.com/ActiveBears/Semester/internal/infrastructure"

func main() {
	infrastructure.RunHttpServer(
		infrastructure.NewLogger(),
		infrastructure.NewRouter(),
	)
}
