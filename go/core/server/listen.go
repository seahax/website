package server

import (
	"fmt"
	"log/slog"
	"net/http"
	"time"

	"seahax.com/go/shorthand"
	"seahax.com/go/xhttp"
	"seahax.com/go/xhttp/middleware/compression"
	"seahax.com/go/xhttp/middleware/logging"
	"seahax.com/go/xhttp/middleware/security"
)

func Listen(routes xhttp.Routes) {
	config := shorthand.CriticalValue(GetConfig())

	info := map[string]any{
		"commit":         config.Commit,
		"environment":    config.Environment,
		"buildTimestamp": config.BuildTimestamp,
		"startTimestamp": time.Now().Unix(),
	}

	routes = xhttp.NewRoutes(routes)
	routes.RouteFunc("GET /_info", func(writer http.ResponseWriter, request *http.Request) {
		writer.Header().Set("Cache-Control", "no-cache")
		xhttp.WriteJSON(writer, request, info)
	})

	handler := routes.HandlerWithMiddleware(
		logging.Default,
		compression.Default,
		security.Default,
	)

	addr, server := xhttp.Listen(&http.Server{Addr: config.Address, Handler: handler})
	slog.Debug(fmt.Sprintf("listening on http://%s", addr))

	shorthand.WaitForSignal()
	slog.Debug("shutting down")

	xhttp.Shutdown(server)
	slog.Debug("shutdown complete")
}
