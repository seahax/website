package limitter

import (
	"context"
	"time"

	"go.mongodb.org/mongo-driver/v2/mongo"
	"go.mongodb.org/mongo-driver/v2/mongo/options"
)

type Limitter struct {
	Count      int
	Duration   time.Duration
	Collection *mongo.Collection
}

type limitDto struct {
	key  string    `bson:"key"`
	time time.Time `bson:"time"`
}

func New(count int, duration time.Duration, collection *mongo.Collection) (*Limitter, error) {
	limitter := &Limitter{
		Count:      count,
		Duration:   duration,
		Collection: collection,
	}

	if err := bootstrap(collection, duration); err != nil {
		return nil, err
	}

	return limitter, nil
}

func (l *Limitter) Allow(key string) (bool, error) {
	return false, nil
}

func bootstrap(collection *mongo.Collection, duration time.Duration) error {
	_, err := collection.Indexes().CreateOne(context.TODO(), mongo.IndexModel{
		Keys:    map[string]any{"key": 1, "time": 1},
		Options: options.Index().SetName("limitter_unique_key").SetUnique(true),
	})

	if err != nil {
		return err
	}

	// TODO: Initialize the collection.

	return nil
}
