package mongodb

import (
	"godo/internal/command/mongodb/create_user"

	"seahax.com/go/command"
)

var Command = command.Namespace("mongodb", "Database management commands.",
	create_user.Command,
)
