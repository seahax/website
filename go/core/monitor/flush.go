package monitor

import (
	"time"

	"github.com/getsentry/sentry-go"
)

func Flush() {
	sentry.Flush(10 * time.Second)
}
