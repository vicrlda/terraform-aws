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
  ami           = var.amis["us-east-2"]
  instance_type = "t2.micro"
  key_name      = var.key_name
  tags = {
    Name = "dev5"
  }
  vpc_security_group_ids = [ "${aws_security_group.ssh-access.id}" ]
}

resource "aws_instance" "dev6" {
  provider      = aws.us-east-1
  ami           = var.amis["us-east-1"]
  instance_type = "t2.micro"
  key_name      = var.key_name
  tags = {
    Name = "dev6"
  }
  vpc_security_group_ids = [ "${aws_security_group.ssh-access-us-east-1.id}" ]
  depends_on = [
    aws_dynamodb_table.HOMOLOG-dynamodb
  ]
}

resource "aws_s3_bucket" "dev4" {
  bucket = "srv-dev4"
  acl = "private"

  tags = {
    Name        = "srv-dev4"
  }
}

resource "aws_dynamodb_table" "HOMOLOG-dynamodb" {
  provider = aws.us-east-1
  name           = "GameScores"
  billing_mode   = "PAY_PER_REQUEST"
  #read_capacity  = 20
  #write_capacity = 20
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }
}
