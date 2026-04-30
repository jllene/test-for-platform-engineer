variable "bucket_alblog" {
  description = "s3 bucket for alb logs"
  default = "test-platform-engineer-abllog-dev"
}

variable "bucket_deployment" {
  description = "s3 bucket for deployment"
  default = "dev_deployment"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-west-2"
}

variable "aws_profile" {
  description = "AWS credential profile name"
  default     = "test-dev"
}

variable "shared_creds" {
  description = "creds file"
  default     = "~/.aws/credentials"
}

variable "account_id" {
  description = "DEV AWS Account ID"
  default     = "123456789"
}

variable "available_zones" {
  type        = list
  description = "availability_zones for Aurora"
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "traffic_distribution" {
  description = "Levels of traffic distribution should be blue/green"
  default = "blue"
}

variable "enable_blue_env" {
  description = "Enable blue environment"
  default = true
}

variable "enable_green_env" {
  description = "Enable green environment"
  default = true
}

variable "image_uri" {
  type = string
}
