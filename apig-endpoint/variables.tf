variable "rest_api" {
  type = object({
    id               = string
    root_resource_id = string
    execution_arn    = string
  })
}

variable "parent_id" {
  type    = string
  default = null
}

variable "path" {
  type = string
}

variable "http_method" {
  type = string
}

variable "lambda" {
  type = object({
    function_name = string
    arn           = string
  })
}

variable "authorizer_id" {
  type    = string
  default = null
}

variable "authorizer_type" {
  type        = string
  description = "Authorizer type: NONE | CUSTOM | AWS_IAM | COGNITO_USER_POOLS"
  default     = null
}
