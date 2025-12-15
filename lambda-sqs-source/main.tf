resource "aws_lambda_event_source_mapping" "this" {
  function_name           = var.lambda.function_name
  event_source_arn        = var.queue.queue_arn
  function_response_types = ["ReportBatchItemFailures"]
}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "AllowReceive"
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ChangeMessageVisibility"
    ]
    resources = [
      var.queue.queue_arn,
    ]
  }

  statement {
    sid    = "AllowDLQSend"
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl"
    ]
    resources = [
      var.queue.dlq_arn,
    ]
  }
}

resource "aws_iam_role_policy" "this" {
  name_prefix = "sqs-event-source-"
  role        = var.lambda.role_id
  policy      = data.aws_iam_policy_document.this.json
}
