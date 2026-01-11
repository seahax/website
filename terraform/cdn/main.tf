module "spa" {
  source      = "github.com/seahax/terraform/aws-cdn"
  name        = "seahax"
  region      = "us-west-2"
  domains     = ["seahax.com", "www.seahax.com"]
  certificate = "arn:aws:acm:us-east-1:194722422414:certificate/ef628864-f3dd-4d46-8d5e-b2e4bcf7a5e4"
  content_security_policy = join(";", [
    "default-src 'self'",
    "connect-src 'self' https://auth0.seahax.com https://*.sentry.io",
    "script-src-attr 'none'",
    "style-src 'self' 'unsafe-inline'",
    "img-src 'self' data: https:",
    "font-src 'self' data:",
    "object-src 'none'",
    "base-uri 'self'",
    "form-action 'self'",
    "frame-ancestors 'self'"
  ])
  # force_destroy = true
}
