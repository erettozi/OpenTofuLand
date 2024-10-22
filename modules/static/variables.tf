variable "aws_region" {
  description = "AWS region name"
  type        = string
}

variable "aws_profile" {
  description = "AWS credentials profile"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "name" {
  description = "Name of the bucket"
  type        = string
}

variable "slug" {
  description = "Generic identifier"
  type        = string
}

variable "certificate_arn" {
  description = "Certificate ARN for the bucket domain"
  type        = string
}

variable "price_class" {
  description = "Cloudfront price class"
  type        = string
  default     = "PriceClass_100"
}

variable "compress" {
  description = "Enable compression"
  type        = bool
  default     = false
}

variable "zone_id" {
  description = "The ID of the hosted zone to create the record in"
  type        = string
}

variable "credentials" {
  description = "Base64-encoded credentials for basic authentication"
  type        = string
  default     = ""
}

variable "enable_credentials" {
  description = "Enable Base64-encoded credentials for basic authentication"
  type        = bool
  default     = false
}