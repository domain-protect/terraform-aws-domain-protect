provider "aws" {
  default_tags {
    tags = var.tags
  }
}

provider "archive" {}
provider "null" {}
provider "random" {}