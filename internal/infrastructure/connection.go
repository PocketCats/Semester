package infrastructure

import (
	"database/sql"
	"fmt"
	"github.com/ActiveBears/Semester/config"
	_ "github.com/lib/pq"
)

type Connection struct {
	conn *sql.DB
}

func NewConnection(c *config.Config) *Connection {
	dsn := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		c.Database.Host, c.Database.Port, c.Database.User, c.Database.Password, c.Database.Name,
	)

	conn, err := sql.Open(c.Database.Driver, dsn)
	if err != nil {
		panic("can't open database connection: " + err.Error())
	}

	if err = conn.Ping(); err != nil {
		panic("can't ping db: " + err.Error())
	}

	return &Connection{conn}
}
