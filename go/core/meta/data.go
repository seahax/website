package meta

type Data struct {
	StartTimestamp int64
	BuildTimestamp int64  `env:"BUILD_TIMESTAMP"`
	Commit         string `env:"COMMIT"`
	Environment    string `env:"ENVIRONMENT" validate:"oneof=development production"`
}
