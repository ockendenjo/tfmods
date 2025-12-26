output "arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.main.arn
}

output "invoke_arn" {
  description = "Lambda function Invoke ARN"
  value       = aws_lambda_function.main.invoke_arn
}

output "function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.main.function_name
}

output "role_id" {
  description = "IAM Role"
  value       = aws_iam_role.main.id
}
