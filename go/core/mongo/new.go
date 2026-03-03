package mongo

import (
	"go.mongodb.org/mongo-driver/v2/mongo"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
)

func New() (*mongo.Client, error) {
	config, err := GetConfig()

	if err != nil {
		return nil, err
	}

	serverOptions := options.ServerAPI(options.ServerAPIVersion1)
	clientOptions := options.Client().ApplyURI(config.Url).SetServerAPIOptions(serverOptions)

	return mongo.Connect(nil, clientOptions)
}
