resource "aws_s3_bucket_policy" "static_read_ew1" {
  bucket = var.bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontRead"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = "s3:GetObject"
        Resource = [
          var.bucket.arn,
          "${var.bucket.arn}/*"
        ]
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.cloudfront_arns
          }
        }
      }
    ]
  })
}
