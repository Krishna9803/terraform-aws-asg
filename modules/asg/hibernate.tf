resource "aws_lambda_function" "hibernate_handler" {
  function_name    = "${var.name_prefix}-hibernate-handler"
  filename         = "lambda.zip"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  role             = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256("lambda.zip")
  timeout          = 60
}

resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hibernate_handler.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.lifecycle_notifications.arn
}

resource "aws_sns_topic_subscription" "lambda_sub" {
  topic_arn = aws_sns_topic.lifecycle_notifications.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.hibernate_handler.arn
}


# ASG Lifecycle Hook
resource "aws_autoscaling_lifecycle_hook" "hibernate_hook" {
  name                    = "${var.name_prefix}-hibernate-hook"
  autoscaling_group_name  = var.name_prefix
  lifecycle_transition    = "autoscaling:EC2_INSTANCE_TERMINATING"
  default_result          = "CONTINUE"
  heartbeat_timeout       = 600
  notification_target_arn = aws_sns_topic.lifecycle_notifications.arn
  role_arn                = aws_iam_role.lambda_exec.arn
}
