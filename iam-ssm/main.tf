locals {
  ssm_statements = flatten([
    [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParametersByPath",
        ]
        Resource = [
          var.ssm_arn,
        ]
      }
    ],
    var.allow_write ? [{
      Effect = "Allow"
      Action = [
        "ssm:PutParameter",
      ]
      Resource = [
        var.ssm_arn
      ]
    }] : [],
    var.allow_delete ? [{
      Effect = "Allow"
      Action = [
        "ssm:DeleteParameter"
      ]
      Resource = [
        var.ssm_arn
      ]
    }] : []
  ])
}

resource "aws_iam_role_policy" "ssm_access" {
  name_prefix = "ssm-access-"
  role        = var.role_id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = local.ssm_statements
  })
}
