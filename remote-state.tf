# Using a single workspace:
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "vicrldacombr"

    workspaces {
      name = "aws-victor"
    }
  }
}