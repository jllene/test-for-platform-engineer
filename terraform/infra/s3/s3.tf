resource "aws_s3_bucket" "s3_alb_log" {
  bucket = var.bucket_alblog
  acl    = "private"
  force_destroy = false

  lifecycle_rule {
    enabled = true
    expiration {
      days = 90
    }
    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }
    noncurrent_version_transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.bucket_alblog}/AWSLogs/123456789/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.bucket_alblog}"
        },
        {
            "Sid": "AllowSSLRequestsOnly",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.bucket_alblog}",
                "arn:aws:s3:::${var.bucket_alblog}/*"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
EOF
}

resource "aws_s3_bucket" "s3_deployment" {
  bucket        = var.bucket_deployment
  force_destroy = false

  lifecycle_rule {
    enabled = true
    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }
    noncurrent_version_transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowSSLRequestsOnly",
        "Effect": "Deny",
        "Principal": "*",
        "Action": "s3:*",
        "Resource": [
            "arn:aws:s3:::${var.bucket_deployment}",
            "arn:aws:s3:::${var.bucket_deployment}/*"
        ],
        "Condition": {
            "Bool": {
                "aws:SecureTransport": "false"
            }
        }
      }
    ]
  }
EOF
}

