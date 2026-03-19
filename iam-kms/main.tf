locals {
  kms_statements = flatten([
    var.allow_decrypt ? [{
      Effect = "Allow"
      Action = [
        "kms:Decrypt",
        "kms:GenerateDataKey",
      ]
      Resource = [
        var.kms_arn,
      ]
    }] : [],
    var.allow_encrypt ? [{
      Effect = "Allow"
      Action = [
        "kms:Encrypt",
        "kms:GenerateDataKey",
      ]
      Resource = [
        var.kms_arn,
      ]
    }] : [],
  ])
}

resource "aws_iam_role_policy" "kms_access" {
  name_prefix = "kms-access-"
  role        = var.role_id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = local.kms_statements
  })
}
