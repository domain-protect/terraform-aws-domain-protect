provider "aws" {
  region = var.region
  default_tags {
    tags = var.tags
  }
}

provider "archive" {}
provider "null" {}
provider "random" {}
