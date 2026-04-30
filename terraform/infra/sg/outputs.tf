output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "redis_sg_id" {
  value = aws_security_group.redis_sg.id
}

output "lambda_sg_id" {
  value = aws_security_group.lambda_sg.id
}