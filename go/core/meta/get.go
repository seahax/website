package meta

import "seahax.com/go/env"

func Get() (*Data, error) {
	return env.Get[Data](
		env.OptionPrefix("APP_"),
		env.OptionPlaygroundValidator(),
	)
}
