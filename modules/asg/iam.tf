resource "aws_iam_role" "ec2" {
  name_prefix        = "${var.name_prefix}-ec2-role-"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

resource "aws_iam_instance_profile" "ec2" {
  name_prefix = "${var.name_prefix}-ec2-profile-"
  role        = aws_iam_role.ec2.name
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "ec2" {
  name_prefix = "ec2-permissions-"
  role        = aws_iam_role.ec2.name
  policy      = data.aws_iam_policy_document.ec2_permissions.json
}

data "aws_iam_policy_document" "ec2_permissions" {
  statement {
    actions = [
      "ssm:GetParameter",
      "s3:GetObject"
    ]
    resources = ["*"]
  }
}





resource "aws_iam_role" "lambda_exec" {
  name_prefix = "${var.name_prefix}-lambda-"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "lambda_hibernation" {
  name_prefix = "${var.name_prefix}-lambda-hibernate-"
  policy      = data.aws_iam_policy_document.lambda_permissions.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_custom" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_hibernation.arn
}

data "aws_iam_policy_document" "lambda_permissions" {
  statement {
    actions = [
      "autoscaling:CompleteLifecycleAction",
      "ec2:StopInstances",
      "ec2:DescribeInstances"
    ]
    resources = ["*"]
  }
}
