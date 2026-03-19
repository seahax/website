package meta

import "seahax.com/go/env"

func Get() (*Data, error) {
	return env.BindWithPrefix[Data]("APP_")
}
