output "autoscaling_group_name" {
  value = aws_autoscaling_group.this.name
}

output "sns_topic_arn" {
  value = aws_sns_topic.lifecycle_notifications.arn
}


output "lambda_function_name" {
  value = aws_lambda_function.hibernate_handler.function_name
}
