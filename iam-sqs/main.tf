resource "aws_iam_role_policy" "sqs_publish" {
  name_prefix = "sqs-publish-"
  role        = var.role_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
        ]
        Resource = var.sqs_arns
      }
    ]
  })
}
