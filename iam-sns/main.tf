resource "aws_iam_role_policy" "sns_publish" {
  name_prefix = "sns-publish-"
  role        = var.role_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish",
        ]
        Resource = var.sns_arns
      }
    ]
  })
}
