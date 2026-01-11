terraform {
  required_version = "~> 1.14.1"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket              = "tfstates-194722422414"
    region              = "us-west-2"
    key                 = "seahax-api.tfstate"
    allowed_account_ids = ["194722422414"]
    # use_lockfile        = true
  }
}

provider "digitalocean" {}
