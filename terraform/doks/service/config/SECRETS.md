# Secrets

The following files are required, but not checked into source control.

## .secret-env.yaml ([file](.secret-env.yaml))

Environment variables that contain sensitive information or information related to sensitive information.

```yaml
APP_SENTRY_DSN: <dsn>
APP_MONGODB_URL: mongodb+srv://<user>:<password>@<host>/<database>?replicaSet=<cluster>&tls=true&authSource=admin
APP_SMTP_SERVER: smtp.protonmail.ch
APP_SMTP_PORT: "587"
APP_SMTP_USERNAME: noreply@seahax.com
APP_SMTP_TOKEN: <token>
```

## .secret-regcred.json ([file](.secret-regcred.json))

Docker registry credentials.

```json
{
  "auths": {
    "https://ghcr.io": {
      "username": "<username>",
      "password": "<token>",
      "auth": "<base64-username-password>"
    }
  }
}
```
