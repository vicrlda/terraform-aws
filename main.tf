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

data "aws_vpc" "default" {
  default = true
}

resource "aws_s3_bucket" "dev4" {
  bucket = "srv-dev4"
  acl = "private"

  tags = {
    Name        = "srv-dev4"
  }
}

resource "aws_security_group" "ssh-access" {
  name        = "ssh-access"
  description = "Allow SSH inbound traffic"
  #vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["187.19.208.26/32"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-access"
  }
}
