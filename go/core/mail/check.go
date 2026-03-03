package mail

import (
	"fmt"
	"log/slog"
)

// Panics if unable to dial the SMTP server.
func Check() error {
	slog.Debug("pinging SMTP")
	client, err := New()

	if err != nil {
		return err
	}

	if err = client.Ping(); err != nil {
		return fmt.Errorf("failed pinging SMTP: %w", err)
	}

	slog.Debug("succeeded pinging SMTP")
	return nil
}
