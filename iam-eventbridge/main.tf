resource "aws_iam_role_policy" "eventbridge_publish" {
  name_prefix = "eventbridge-publish-"
  role        = var.role_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "events:PutEvents",
        ]
        Resource = var.bus_arns
      }
    ]
  })
}
