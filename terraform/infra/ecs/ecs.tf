resource "aws_ecs_cluster" "test_cluster" {
  name = "test-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "test_task" {
  family                   = "my-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([
    {
      name      = "app"
      image     = var.image_uri
      portMappings = [{
        containerPort = 5000
      }]
    }
  ])
}

resource "aws_ecs_service" "test_service" {
  name            = "test-service"
  cluster         = aws_ecs_cluster.test_cluster.name
  task_definition = aws_ecs_task_definition.test_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_list
    security_groups  = [var.web_sg_id]
    assign_public_ip = false
  }
}
