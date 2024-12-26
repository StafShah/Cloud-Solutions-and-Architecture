output "scheduler_arn" {
  value = aws_cloudwatch_event_rule.trigger_rule.arn
}