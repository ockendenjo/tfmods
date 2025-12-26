locals {
  prefix     = "${var.project_name}-"
  log_prefix = var.project_name
  suffix     = "-${var.aws_env}"
}

resource "aws_lambda_function" "main" {
  function_name = "${local.prefix}${var.name}${local.suffix}"
  role          = aws_iam_role.main.arn
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_object_key
  runtime       = "provided.al2023"
  handler       = "bootstrap"
  architectures = ["arm64"]
  memory_size   = 1024
  timeout       = 10
  environment {
    variables = merge({
      AWS_ENV = var.aws_env
    }, var.environment)
  }
}

resource "aws_iam_role" "main" {
  name = "${local.prefix}lambda-${var.name}${local.suffix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  permissions_boundary = var.permissions_boundary_arn
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/lambda/${aws_lambda_function.main.function_name}"
  retention_in_days = 30
  skip_destroy      = false
}

resource "aws_cloudwatch_log_metric_filter" "error_logging" {
  name           = "${local.prefix}${var.name}${local.suffix}-errors"
  log_group_name = aws_cloudwatch_log_group.main.name
  pattern        = "{$.level = \"ERROR\"}"

  metric_transformation {
    name      = "${var.name}_error_count"
    namespace = local.log_prefix
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "error_logging" {
  alarm_name          = "${local.prefix}${var.name}${local.suffix}-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "${var.name}_error_count"
  namespace           = "${local.log_prefix}/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Triggers when ${var.name} has more than 1 error in a minute"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.alarm_topic_arn]
}
