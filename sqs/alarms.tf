resource "aws_cloudwatch_metric_alarm" "dlq_length" {
  count               = var.alarm_topic_arn != null ? 1 : 0
  alarm_name          = "${local.full_name}-dlq-length"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "Triggers when DLQ has messages"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.alarm_topic_arn]
  dimensions = {
    QueueName = aws_sqs_queue.dlq.name
  }
}
