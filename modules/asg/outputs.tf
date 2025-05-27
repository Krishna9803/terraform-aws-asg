output "asg_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.this.name
}

output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.hibernate_handler.arn
}

output "sns_topic_arn" {
  value = aws_sns_topic.lifecycle_notifications.arn
  description = "The ARN of the SNS topic for lifecycle notifications."
}

output "launch_template_id" {
  value = aws_launch_template.this.id
  description = "The ID of the Launch Template used by the ASG."
}

output "lifecycle_hook_name" {
  value = aws_autoscaling_lifecycle_hook.hibernate_hook.name
  description = "The name of the lifecycle hook for hibernation."
}
