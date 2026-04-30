resource "aws_elasticache_replication_group" "redis-repl" {
  replication_group_id          = var.redis_replication_name
  description                   = "redis replication group"
  auto_minor_version_upgrade    = true
  automatic_failover_enabled    = true
  engine                        = "redis"
  engine_version                = var.redis_engine_version
  maintenance_window            = "mon:05:00-mon:06:00"
  node_type                     = var.redis_node_type
  num_cache_clusters            = var.redis_node_numbers
  parameter_group_name          = aws_elasticache_parameter_group.redis-params.name
  port                          = 6379
  security_group_ids            = [var.redis_sg]
  snapshot_retention_limit      = 7
  subnet_group_name             = aws_elasticache_subnet_group.redis-subnet-group.name
  apply_immediately             = true
  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = true
  auth_token                    = var.redis_auth
}

resource "aws_elasticache_parameter_group" "redis-params" {
  name        = var.redis_parameter_group
  description = "Redis param group"
  family      = var.redis_parameter_group_family

  parameter {
    name  = "repl-backlog-ttl"
    value = "3600"
  }

  parameter {
    name  = "tcp-keepalive"
    value = "300"
  }

  parameter {
    name  = "cluster-require-full-coverage"
    value = "no"
  }
}

resource "aws_elasticache_subnet_group" "redis-subnet-group" {
  name        = var.redis_subnet_group
  description = "Redis subnet group"
  subnet_ids  = var.redis_subnet_list
}

# Cloud Watch Metric Alarm - Redis Current Connection Alarm
resource "aws_cloudwatch_metric_alarm" "redis_alarm_current_connection" {
  alarm_name                = "redis_alarm_current_connection_stg"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "3"
  metric_name               = "CurrConnections"
  namespace                 = "AWS/ElastiCache"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "1000"
  alarm_description         = "Redis CurrConnections > 1000 within 15 minutes"
  datapoints_to_alarm       = 3
  insufficient_data_actions = []
  alarm_actions             = ["arn:aws:sns:us-west-2:123456789:TEST"]
  lifecycle {
    create_before_destroy = true
  }
  depends_on                = [aws_elasticache_replication_group.redis-repl]
}

# Cloud Watch Metric Alarm - Redis Freeable Memory Alarm
resource "aws_cloudwatch_metric_alarm" "redis_alarm_freeable_memory_stg" {
  alarm_name                = "redis_alarm_freeable_memory_stg"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "3"
  metric_name               = "FreeableMemory"
  namespace                 = "AWS/ElastiCache"
  period                    = "300"
  statistic                 = "Minimum"
  threshold                 = "1000000000"
  alarm_description         = "Redis FreeableMemory < 1G within 15 minutes"
  insufficient_data_actions = []
  alarm_actions             = ["arn:aws:sns:us-west-2:123456789:TEST"]
  lifecycle {
    create_before_destroy = true
  }
  depends_on                = [aws_elasticache_replication_group.redis-repl]
}

# Cloud Watch Metric Alarm - Redis CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "redis_alarm_cpu_utilization" {
  alarm_name                = "redis_alarm_cpu_utilization"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "3"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ElastiCache"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "60"
  alarm_description         = "Redis average CPUUtilization > 60 within 15 minutes"
  insufficient_data_actions = []
  alarm_actions             = ["arn:aws:sns:us-east-1:123456789:TEST"]
  lifecycle {
    create_before_destroy = true
  }
  depends_on                = [aws_elasticache_replication_group.redis-repl]
}