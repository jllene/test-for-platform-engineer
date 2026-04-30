output "alb_arn" {
  value = aws_alb.test_alb.arn
}

output "alb_tg_arn" {
  value = aws_lb_target_group.test_alb_tg.arn
}

output "alb_tg_arn_suffix" {
  value = aws_lb_target_group.test_alb_tg.arn_suffix
}