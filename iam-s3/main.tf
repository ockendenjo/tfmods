locals {
  s3_statements = flatten([
    [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.bucket_arn,
          "${var.bucket_arn}/*"
        ]
      }
    ],
    var.allow_write ? [{
      Effect = "Allow"
      Action = [
        "s3:PutObject",
        "s3:PutObjectAcl"
      ]
      Resource = [
        "${var.bucket_arn}/*"
      ]
    }] : [],
    var.allow_delete ? [{
      Effect = "Allow"
      Action = [
        "s3:DeleteObject"
      ]
      Resource = [
        "${var.bucket_arn}/*"
      ]
    }] : []
  ])
}

resource "aws_iam_role_policy" "s3_access" {
  name_prefix = "s3-access-"
  role        = var.role_id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = local.s3_statements
  })
}
