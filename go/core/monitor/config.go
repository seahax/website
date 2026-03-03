package monitor

import (
	"log/slog"

	"seahax.com/go/env"
)

type Config struct {
	LogLevel    slog.Level `env:"LOG_LEVEL"`
	LogFormat   string     `env:"LOG_FORMAT" validate:"omitempty,oneof=text json"`
	SentryDSN   string     `env:"SENTRY_DSN" validate:"omitempty,url"`
	SentryDebug bool       `env:"SENTRY_DEBUG" validate:"omitempty"`
}

func GetConfig() (*Config, error) {
	return env.Get[Config](
		env.OptionPrefix("APP_"),
		env.OptionPlaygroundValidator(),
	)
}
