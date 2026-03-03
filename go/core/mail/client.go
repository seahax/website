package mail

import (
	"context"

	"github.com/wneessen/go-mail"
	"seahax.com/go/shorthand"
)

type Client struct {
	config *Config
	retry  *shorthand.Retry
}

func (c *Client) Send(to string, subject string, body Body) error {
	msg := mail.NewMsg()

	if err := msg.From(c.config.Username); err != nil {
		return err
	}

	if err := msg.To(to); err != nil {
		return err
	}

	msg.Subject(subject)

	if body.Text != "" {
		msg.SetBodyString(mail.TypeTextPlain, body.Text)
	}

	if body.Html != "" {
		msg.SetBodyString(mail.TypeTextHTML, body.Html)
	}

	return c.WithMailClient(func(mc *mail.Client) error {
		return mc.DialAndSend(msg)
	})
}

func (c *Client) Ping() error {
	return c.WithMailClient(func(mc *mail.Client) error {
		return mc.DialWithContext(context.Background())
	})
}

func (c *Client) WithMailClient(cb func(client *mail.Client) error) error {
	mc, err := mail.NewClient(c.config.Server,
		mail.WithPort(int(c.config.Port)),
		mail.WithSMTPAuth(mail.SMTPAuthPlain),
		mail.WithUsername(c.config.Username),
		mail.WithPassword(c.config.Token),
	)

	if err != nil {
		return err
	}

	defer mc.Close()

	return c.retry.Do(func() error {
		return mc.DialWithContext(context.Background())
	})
}
