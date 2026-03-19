package main

import (
	"godo/internal/command/mongodb"

	"seahax.com/go/command"
)

func main() {
	command.Namespace("godo", "DigitalOcean management utility commands.",
		mongodb.Command,
	).RunAndExit()
}
