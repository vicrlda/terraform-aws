variable "amis" {

    type = map

    default = {
        "us-east-1" = "ami-09cce346b3952cce3"
        "us-east-2" = "ami-045137e8d34668746"
    }
  
}

variable "ips_remotos" {

    type = list

    default = ["187.19.211.170/32","188.19.211.170/32"]
  
}

variable "key_name" {

    default = "terraform-kali"
  
}