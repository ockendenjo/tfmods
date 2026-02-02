locals {
  prefix    = "${var.project_name}-"
  suffix    = "-${var.aws_env}"
  full_name = "${local.prefix}${var.name}${local.suffix}"
}

resource "aws_sqs_queue" "dlq" {
  name                       = "${local.full_name}-dlq"
  message_retention_seconds  = var.dlq_message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
}

resource "aws_sqs_queue" "this" {
  name                       = local.full_name
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = var.max_receive_count
  })
}
