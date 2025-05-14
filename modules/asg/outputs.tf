output "autoscaling_group_name" {
  value = aws_autoscaling_group.this.name
}



output "lambda_function_name" {
  value = aws_lambda_function.hibernate_handler.function_name
}
