resource "aws_api_gateway_resource" "main" {
  rest_api_id = var.rest_api.id
  parent_id   = var.parent_id != null ? var.parent_id : var.rest_api.root_resource_id
  path_part   = var.path
}

resource "aws_api_gateway_method" "main" {
  rest_api_id   = var.rest_api.id
  resource_id   = aws_api_gateway_resource.main.id
  http_method   = var.http_method
  authorization = var.authorizer_id != null ? coalesce(var.authorizer_type, "CUSTOM") : "NONE"
  authorizer_id = var.authorizer_id
}

data "aws_region" "current" {}

resource "aws_api_gateway_integration" "main" {
  rest_api_id             = var.rest_api.id
  resource_id             = aws_api_gateway_resource.main.id
  http_method             = aws_api_gateway_method.main.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.region}:lambda:path/2015-03-31/functions/${var.lambda.arn}/invocations"
}

resource "aws_lambda_permission" "main" {
  count         = var.add_lambda_invoke_permissions ? 1 : 0
  statement_id  = "AllowAPIGInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.rest_api.execution_arn}/*/*"
}
