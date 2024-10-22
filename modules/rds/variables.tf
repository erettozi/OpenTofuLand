variable "env" {
  type    = string
  default = "dev"
}

variable "db_name" {
  description = "The database name"
  type        = string
}

variable "db_username" {
  description = "The database username"
  type        = string
}

variable "db_password" {
  description = "The database password"
  type        = string
}

variable "db_instance_class" {
  description = "The instance type"
  type        = string
}

variable "db_allocated_storage" {
  description = "The allocated storage in GBs"
  type        = number
}

variable "db_backup_retention" {
  description = "The number of days to retain backups"
  type        = number
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs"
  type        = list(string)
}

variable "param_group_name" {
    description = "The name of the parameter group"
    type        = string
  default = "pg-custom-params"
}