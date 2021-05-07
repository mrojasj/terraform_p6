# Variables

variable "vpc_cidr_block" {
  type = string
}

variable "snet_cidr_block_list" {
  type = list(string)
}

variable "ami" {
  type = string
}

variable "keyName"{
  type = string
}