variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "db_name" {
  description = "Database name"
  default     = "runningcoach"
}

variable "db_username" {
  description = "Database username"
  default     = "postgres"
}

variable "db_password" {
  description = "Database password"
  sensitive   = true
}
