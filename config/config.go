package config

import "github.com/caarlos0/env/v10"

type Config struct {
	Database struct {
		Driver   string `env:"DB_DRIVER"`
		Host     string `env:"DB_HOST"`
		Name     string `env:"DB_NAME"`
		Port     string `env:"DB_PORT"`
		User     string `env:"DB_USER"`
		Password string `env:"DB_PASSWORD"`
	}
}

func NewConfig() Config {
	conf := Config{}
	if err := env.Parse(&conf); err != nil {
		panic("Warn: Env variables should be provided in OS environment before starting application\n" + err.Error())
	}

	return conf
}
