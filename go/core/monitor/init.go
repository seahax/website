package monitor

import (
	"log/slog"
	"os"
	"seahax/core/meta"

	"github.com/getsentry/sentry-go"
)

func Init() error {
	config, err := GetConfig()

	if err != nil {
		return err
	}

	meta, err := meta.Get()

	if err != nil {
		return err
	}

	logOptions := &slog.HandlerOptions{Level: config.LogLevel}

	if config.SentryDSN != "" {
		logOptions.ReplaceAttr = func(_ []string, attr slog.Attr) slog.Attr {
			// If the attribute value is an error, send it to Sentry and replace the
			// attribute with the Sentry event ID.
			if err, ok := attr.Value.Any().(error); ok {
				id := sentry.CaptureException(err)
				return slog.String("sentry_"+attr.Key, string(*id))
			}

			return attr
		}

		err := sentry.Init(sentry.ClientOptions{
			Dsn:            config.SentryDSN,
			Debug:          config.SentryDebug,
			Environment:    meta.Environment,
			SendDefaultPII: true,
		})

		if err != nil {
			return err
		}
	}

	if config.LogFormat == "json" {
		slog.SetDefault(slog.New(slog.NewJSONHandler(os.Stdout, logOptions)))
	} else {
		slog.SetDefault(slog.New(slog.NewTextHandler(os.Stdout, logOptions)))
	}

	return nil
}
