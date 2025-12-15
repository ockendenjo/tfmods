variable "lambda" {
  type = object({
    function_name = string
    role_id       = string
  })
}

variable "queue" {
  type = object({
    queue_arn = string
    dlq_arn   = string
  })
}
