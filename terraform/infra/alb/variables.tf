variable "public_subnet_list" {
  description = "Subnets for ALB"
  type        = list
}

variable "vpc_id" {
  description = "VPC id"
}

variable "alb_sg_id" {
  description = "alb sg"
}

variable "bucket_alblog" {
  description = "bucket for alb logs"
}