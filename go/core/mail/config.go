package mail

import "seahax.com/go/env"

type Config struct {
	Server   string `env:"SERVER" validate:"hostname"`
	Port     uint   `env:"PORT" validate:"port"`
	Username string `env:"USERNAME" validate:"email"`
	Token    string `env:"TOKEN" validate:"required"`
}

func GetConfig() (*Config, error) {
	return env.BindWithPrefix[Config]("APP_SMTP_")
}
