output "cluster_address" {
    value = aws_elasticache_replication_group.redis-repl.primary_endpoint_address
}

output "redis_subnet_group" {
    value = aws_elasticache_subnet_group.redis-subnet-group.name
}

output "redis_parameter_group" {
    value = aws_elasticache_parameter_group.redis-params.name
}