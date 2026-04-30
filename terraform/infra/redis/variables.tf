variable "vpc_id" {
  description = "VPC ID"
}

variable "redis_subnet_list" {
  description = "Subnets for redis"
  type        = list
}

variable "redis_sg" {
  description = "security group for redis cluster"
}

variable "redis_replication_name" {
  description = "replication_group_id for redis cluster"
  default     = "redis-repl-new"
}

variable "redis_node_type" {
  description = "node type for redis cluster"
  default     = "cache.r5.large"
}

variable "redis_node_numbers" {
  description = "number_cache_clusters for redis cluster"
  default     = 2
}

variable "redis_parameter_group" {
  description = "redis parameter group anme"
  default     = "redis-parameter-new"
}

variable "redis_subnet_group" {
  description = "redis subnet group name"
  default     = "redis-subnet-new"
}

variable "redis_auth" {
  type        = string
  description = "The password userd to access a password protected server."
}

variable "redis_engine_version" {
  description = "engine version for redis cluster"
  default     = "7.0"
}

variable "redis_parameter_group_family" {
  description = "redis parameter group family"
  default     = "redis7"
}
