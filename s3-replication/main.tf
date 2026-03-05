terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 6.0"
      configuration_aliases = [aws.src, aws.dst]
    }
  }
}

resource "aws_iam_role" "main" {
  name_prefix = "bogale-s3-${var.env}-replication-"
  provider    = aws.src

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = ["sts:AssumeRole"]
      }
    ]
  })

  permissions_boundary = var.permissions_boundary_arn
}

resource "aws_iam_role_policy" "main" {
  provider = aws.src
  role     = aws_iam_role.main.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowSource"
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket",
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
        ]
        Effect = "Allow"
        Resource = concat(
          [
            var.source_bucket.arn,
            "${var.source_bucket.arn}/*",
          ],
          var.replicate_back ? [
            var.target_bucket.arn,
            "${var.target_bucket.arn}/*",
          ] : []
        )
      },
      {
        Sid = "AllowDestination"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
        ]
        Effect = "Allow"
        Resource = concat(
          [
            "${var.target_bucket.arn}/*"
          ],
          var.replicate_back ? [
            "${var.source_bucket.arn}/*"
          ] : []
        )
      }
    ]
  })
}

resource "aws_s3_bucket_replication_configuration" "source_to_target" {
  provider = aws.src
  bucket   = var.source_bucket.id
  role     = aws_iam_role.main.arn

  rule {
    id = "copy-all"

    filter {
      prefix = ""
    }

    status = "Enabled"

    destination {
      bucket        = var.target_bucket.arn
      storage_class = "STANDARD"

      metrics {
        event_threshold {
          minutes = 15
        }
        status = "Enabled"
      }

      replication_time {
        status = "Enabled"
        time {
          minutes = 15
        }
      }
    }

    delete_marker_replication {
      status = "Enabled"
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "target_to_source" {
  provider = aws.dst
  count    = var.replicate_back ? 1 : 0
  bucket   = var.target_bucket.id
  role     = aws_iam_role.main.arn

  rule {
    id = "copy-all"

    filter {
      prefix = ""
    }

    status = "Enabled"

    destination {
      bucket        = var.source_bucket.arn
      storage_class = "STANDARD"

      metrics {
        event_threshold {
          minutes = 15
        }
        status = "Enabled"
      }

      replication_time {
        status = "Enabled"
        time {
          minutes = 15
        }
      }
    }

    delete_marker_replication {
      status = "Enabled"
    }
  }
}
