terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.12.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }
}

provider "aws" {

  assume_role {
    role_arn = "arn:aws:iam::1234567890:role/OrgRole"
  }

  default_tags {
    tags = {
      "service"     = "domain-protect"
      "owner"       = "security"
      "environment" = "nonprod"
      "managed_by"  = "terraform"
    }
  }
}

provider "aws" {
  alias = "org"

  assume_role {
    role_arn = "arn:aws:iam::1234567890:role/OrgRole"
  }

  default_tags {
    tags = {
      "service"     = "domain-protect"
      "owner"       = "security"
      "environment" = "prod"
      "managed_by"  = "terraform"
    }
  }
}

provider "archive" {}
provider "null" {}
provider "random" {}
