package main

import (
	"seahax/core/mail"
	"seahax/core/mongo"
	"seahax/core/monitor"
	"seahax/core/server"

	"seahax.com/go/shorthand"
	"seahax.com/go/xhttp"
)

func main() {
	shorthand.Critical(monitor.Init())
	defer monitor.Flush()

	shorthand.Critical(mongo.Check())
	shorthand.Critical(mail.Check())

	routes := xhttp.NewRoutes()

	server.Listen(routes)
}
