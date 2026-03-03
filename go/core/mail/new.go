package mail

import (
	"time"

	"seahax.com/go/shorthand"
)

func New() (*Client, error) {
	config, err := GetConfig()

	if err != nil {
		return nil, err
	}

	return &Client{
		config: config,
		retry: &shorthand.Retry{
			Count:   3,
			Backoff: shorthand.NewExponentialBackoff(5 * time.Second).WithJitter(),
		},
	}, nil
}
