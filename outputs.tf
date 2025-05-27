output "asg_name" {
  value = module.autoscaling.asg_name
  description = "The name of the Auto Scaling Group."
}

output "lambda_arn" {
  value = module.autoscaling.lambda_function_arn
  description = "The ARN of the Auto Scaling Group."
}

output "sns_topic" {
  value = module.autoscaling.sns_topic_arn
  description = "The ARN of the SNS topic for lifecycle notifications."
}

output "launch_template" {
  value = module.autoscaling.launch_template_id
  description = "The ID of the Launch Template used by the ASG."
}
