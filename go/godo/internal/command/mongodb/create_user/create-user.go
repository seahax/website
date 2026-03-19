package create_user

import (
	"context"
	"fmt"

	"github.com/digitalocean/godo"
)

func createUser(client *godo.Client, clusterId string, database string, userName string, role string) error {
	user, _, err := client.Databases.CreateUser(context.Background(), clusterId, &godo.DatabaseCreateUserRequest{
		Name: userName,
		Settings: &godo.DatabaseUserSettings{
			MongoUserSettings: &godo.MongoUserSettings{
				Databases: []string{database},
				Role:      role,
			},
		},
	})

	if errResponse, ok := err.(*godo.ErrorResponse); ok {
		if errResponse.Message == "user already exists" {
			return fmt.Errorf("User: %s (already exists)\n", userName)
		}
	}

	if err != nil {
		return err
	}

	fmt.Printf("User: %s, Password: %s\n", userName, user.Password)
	return nil
}
