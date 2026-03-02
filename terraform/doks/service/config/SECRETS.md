# Secrets

The following files are required, but not checked into source control.

## .secret-env.yaml ([file](.secret-env.yaml))

Environment variables that contain sensitive information or information related to sensitive information.

```yaml
APP_SENTRY_DSN: https://...ingest.us.sentry.io/...
APP_MONGODB_URL: mongodb+srv://api:...@...mongo.ondigitalocean.com/admin?...
APP_SMTP_SERVER: smtp.protonmail.ch
APP_SMTP_PORT: "587"
APP_SMTP_USERNAME: noreply@seahax.com
APP_SMTP_TOKEN: ...
```

## .secret-regcred.json ([file](.secret-regcred.json))

Docker registry credentials.

```json
{
  "auths": {
    "https://ghcr.io": {
      "username": "...",
      "password": "ghp_...",
      "auth": "..."
    }
  }
}
```
