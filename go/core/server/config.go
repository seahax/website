package server

import (
	"seahax.com/go/env"
)

type Config struct {
	BuildTimestamp int64  `env:"BUILD_TIMESTAMP"`
	Commit         string `env:"COMMIT"`
	Environment    string `env:"ENVIRONMENT" validate:"oneof=development production"`
	Address        string `env:"ADDRESS"`
}

func GetConfig() (*Config, error) {
	return env.BindWithPrefix[Config]("APP_")
}
