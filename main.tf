terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

resource "aws_instance" "app_server" {
  count         = 3
  ami           = "ami-045137e8d34668746"
  instance_type = "t2.micro"
  key_name      = "rootkiv-aws"
  tags = {
    Name = "elastic-computer_${count.index}"
  }
}
