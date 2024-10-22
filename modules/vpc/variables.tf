variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
}

variable "availibilty_zone_1" {
  description = "Availability Zone for the first set of subnets"
  type        = string
}

variable "availibilty_zone_2" {
  description = "Availability Zone for the second set of subnets"
  type        = string
}