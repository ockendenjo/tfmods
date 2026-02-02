variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "name" {
  type        = string
  description = "Queue name"
}

variable "aws_env" {
  type        = string
  description = "AWS environment (e.g., dev, prod)"
}

variable "message_retention_seconds" {
  type        = number
  description = "Message retention period in seconds"
  default     = 345600 # 4 days
}

variable "visibility_timeout_seconds" {
  type        = number
  description = "Visibility timeout in seconds"
  default     = 30
}

variable "receive_wait_time_seconds" {
  type        = number
  description = "Wait time for long polling in seconds"
  default     = 0
}

variable "max_receive_count" {
  type        = number
  description = "Maximum number of receives before sending to DLQ"
  default     = 3
}

variable "dlq_message_retention_seconds" {
  type        = number
  description = "DLQ message retention period in seconds"
  default     = 1209600 # 14 days
}
