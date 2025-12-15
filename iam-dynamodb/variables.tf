variable "dynamo_table_arns" {
  type        = list(string)
  description = "List of DynamoDB table ARNs to grant access to."
}

variable "role_id" {
  type        = string
  description = "Name or unique ID of the IAM role to attach the inline policy to."
}
