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

provider "aws" {
  alias = "us-east-1"
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  count         = 3
  ami           = "ami-045137e8d34668746"
  instance_type = "t2.micro"
  key_name      = "terraform-kali"
  tags = {
    Name = "elastic-computer_${count.index}"
  }
  vpc_security_group_ids = [ "${aws_security_group.ssh-access.id}" ]
}

resource "aws_instance" "dev4" {
  ami           = "ami-045137e8d34668746"
  instance_type = "t2.micro"
  key_name      = "terraform-kali"
  tags = {
    Name = "dev4"
  }
  vpc_security_group_ids = [ "${aws_security_group.ssh-access.id}" ]
  depends_on = [
    aws_s3_bucket.dev4
  ]
}

resource "aws_instance" "dev5" {
  ami           = "ami-045137e8d34668746"
  instance_type = "t2.micro"
  key_name      = "terraform-kali"
  tags = {
    Name = "dev5"
  }
  vpc_security_group_ids = [ "${aws_security_group.ssh-access.id}" ]
}

resource "aws_instance" "dev6" {
  provider      = "aws.us-east-1"
  ami           = "ami-09cce346b3952cce3"
  instance_type = "t2.micro"
  key_name      = "terraform-kali"
  tags = {
    Name = "dev6"
  }
  vpc_security_group_ids = [ "${aws_security_group.ssh-access-us-east-1.id}" ]
}

resource "aws_s3_bucket" "dev4" {
  bucket = "srv-dev4"
  acl = "private"

  tags = {
    Name        = "srv-dev4"
  }
}
