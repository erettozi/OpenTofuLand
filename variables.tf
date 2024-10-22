variable "env" {
  type    = string
  default = "dev"
}

variable "env_long_name" {
  type    = string
  default = "develop"
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "aws_profile" {
  type    = string
  default = "example-dev"
}

variable "account_id" {
  description = "AWS account id"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "example-dev"
}

variable "db_password" {
  description = "The database password"
  type        = string
}

variable "R53_example_develop_wildcard_route_traffic_to_ip" {
  type = string
}