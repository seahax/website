package create_user

import (
	"godo/internal/command/mongodb/validate"

	"github.com/digitalocean/godo"
	"seahax.com/go/command"
	"seahax.com/go/env"
	"seahax.com/go/shorthand"
)

var Command = command.New("create-user", "Create MongoDB database users.", func(opts *Opts) error {
	if err := validate.DatabaseName(opts.Database); err != nil {
		return err
	}

	if err := validate.UsernameSuffix(opts.Suffix); err != nil {
		return err
	}

	env, err := env.Bind[struct {
		Token string `env:"DIGITALOCEAN_ACCESS_TOKEN" validate:"required"`
	}]()

	if err != nil {
		return err
	}

	client := godo.NewFromToken(env.Token)
	userReadWrite := opts.Database + "-" + opts.Suffix
	userReadOnly := opts.Database + "-read-" + opts.Suffix

	if err := createUser(client, opts.ClusterId, opts.Database, userReadWrite, "readWrite"); err != nil {
		return err
	}

	if err := createUser(client, opts.ClusterId, opts.Database, userReadOnly, "readOnly"); err != nil {
		return err
	}

	return nil
}, command.Modify(func(command command.CommandMutable) {
	command.SetUsage(
		"Usage: godo mongodb create-user <cluster> <database> <username-suffix>",
	)
	command.SetPrologue(shorthand.Multiline(`
	| This command creates two MongoDB users (readWrite and readOnly) with
	| permissions scoped to a single database. The two usernames will be:
	|
  |   - readWrite: <database>-<suffix>
	|   - readOnly:  <database>-read-<suffix>
	|
	| For example, if the database name is "accounts", and the suffix is
	| "2026-01-02", then the following users will have access to the
	| "accounts" database:
	|
	|   - readWrite: accounts-2026-01-02
	|   - readOnly:  accounts-read-2026-01-02
	|
	| MongoDB users can only be created (not updated) because DigitalOcean
	| doesn't currently support updating MongoDB users. Therefore, database
	| password rotation is actually database user rotation. To rotate the
	| database users, create new users with a unique suffix.
	`))
}))
