variable "env" {
  type    = string
  default = "dev"
}

variable "account_id" {
  description = "AWS account id"
  type        = string
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "certificate_arn" {
  description = "ACM Certificate ARN"
  type        = string
}

variable "zone_id" {
  description = "Route53 Zone ID"
  type        = string
}

variable "api_domain_name" {
  description = "API domain name"
  type        = string
}

variable "alb_sg_id" {
  description = "ALB security group ID"
  type        = string
}

variable "db_password_secret_arn" {
  description = "RDS password secret ARN"
  type        = string
}

variable "web_api_policy_arn" {
  description = "Web API policy ARN"
  type        = string
}

variable "organization" {
  description = "example, eurohpc"
  type    = string
}
