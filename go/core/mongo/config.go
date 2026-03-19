package mongo

import "seahax.com/go/env"

type Config struct {
	Url string `env:"URL" validate:"url"`
}

func GetConfig() (*Config, error) {
	return env.BindWithPrefix[Config]("APP_MONGODB_")
}
