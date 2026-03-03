package mongo

import "seahax.com/go/env"

type Config struct {
	Url string `env:"URL" validate:"url"`
}

func GetConfig() (*Config, error) {
	return env.Get[Config](
		env.OptionPrefix("APP_MONGODB_"),
		env.OptionPlaygroundValidator(),
	)
}
