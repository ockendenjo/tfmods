terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=6.26.0"
    }
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "DynamoDBTableAccess"
    effect = "Allow"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:DescribeTable",
    ]
    resources = var.allow_index_use ? flatten([
      for arn in var.dynamo_table_arns : [arn, "${arn}/index/*"]
    ]) : var.dynamo_table_arns
  }
}

resource "aws_iam_role_policy" "this" {
  name_prefix = "dynamodb-"
  role        = var.role_id
  policy      = data.aws_iam_policy_document.this.json
}
