output "path_part" {
  value = aws_api_gateway_resource.main.path_part
}

output "resource_id" {
  value = aws_api_gateway_resource.main.id
}

output "method_id" {
  value = aws_api_gateway_method.main.id
}

output "integration_id" {
  value = aws_api_gateway_integration.main.id
}

output "lambda" {
  value = var.lambda
}

output "authorizer_type" {
  value = var.authorizer_type
}

output "authorizer_id" {
  value = var.authorizer_id
}
