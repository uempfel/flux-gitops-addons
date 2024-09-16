terraform {
  required_version = ">= 1.7.0"

  required_providers {
    # flux = {
    #   source  = "fluxcd/flux"
    #   version = ">= 1.2"
    # }
    github = {
      source  = "integrations/github"
      version = ">= 6.1"
    }
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.6"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
  }
}
