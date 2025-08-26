terraform {
  required_version = "> 1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 6.0.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "> 2.2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "> 3.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "> 3.1.0"
    }
  }
}
