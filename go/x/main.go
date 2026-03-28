package main

import (
	"seahax/x/internal/mongodb"

	"seahax.com/go/command"
)

func main() {
	command.Namespace("x", "Project management commands.",
		command.Namespace("mongodb, mongo", "MongoDB management commands.",
			mongodb.CreateUser,
		),
	).RunAndExit()
}
