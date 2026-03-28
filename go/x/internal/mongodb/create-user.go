package mongodb

import (
	"context"
	"fmt"

	"github.com/digitalocean/godo"
	"seahax.com/go/command"
	"seahax.com/go/env"
	"seahax.com/go/shorthand"
)

var CreateUser = command.New("create-user, cu", "Create MongoDB database users.", func(opts *struct {
	ClusterId string `flag:"<cluster>" help:"Database cluster ID" validate:"uuid"`
	Database  string `flag:"<database>" help:"Database name" validate:"required"`
	Suffix    string `flag:"<username-suffix>" help:"Username suffix" validate:"required"`
}) error {
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
}, command.Modify(func(c command.CommandMutable) {
	c.SetUsage(
		"Usage: godo mongodb create-user <cluster> <database> <username-suffix>",
	)
	c.SetPrologue(shorthand.Multiline(`
	| This command creates two MongoDB users (readWrite and readOnly) with
	| permissions scoped to a single database. The two usernames will be:
	|
  |   - readWrite: <database>-<suffix>
	|   - readOnly:  <database>-read-<suffix>
	|
	| For example, if the database name is "accounts", and the suffix is
	| "2026-01-02", then the following users will be created with access to
	| the "accounts" database:
	|
	|   - readWrite: accounts-2026-01-02
	|   - readOnly:  accounts-read-2026-01-02
	`))
}))

func createUser(client *godo.Client, clusterId string, database string, userName string, role string) error {
	fmt.Printf("user: %s", userName)

	user, _, err := client.Databases.CreateUser(context.Background(), clusterId, &godo.DatabaseCreateUserRequest{
		Name: userName,
		Settings: &godo.DatabaseUserSettings{
			MongoUserSettings: &godo.MongoUserSettings{
				Databases: []string{database},
				Role:      role,
			},
		},
	})

	if err != nil {
		fmt.Printf("\n")
		return err
	}

	fmt.Printf(", password: %s\n", user.Password)
	return nil
}
