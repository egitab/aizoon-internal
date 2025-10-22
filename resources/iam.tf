data "aws_caller_identity" "current" {}

### Policies and roles to authorize cross-account access to S3 bucket from remote account

#permission policy
resource "aws_iam_policy" "permission_policy_s3_cross_account" {
  count    = var.s3_cross_account_enabled ? 1 : 0
  name     = local.s3_permission_policy_name
  policy   = jsonencode({
    Version  = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "s3:ListBucket",
        Resource = "arn:aws:s3:::${var.s3_local_bucket}"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject"
        ],
        Resource = "arn:aws:s3:::${var.s3_local_bucket}/${var.s3_local_folder}/*"
      }
    ]
  })
}

#trust policy (role)
resource "aws_iam_role" "role_s3_cross_account" {
  count    = var.s3_cross_account_enabled ? 1 : 0
  name     = "${local.s3_role_name}"
  #permissions_boundary = "${var.ec2_role_01_pbnd_arn}"

  # Allow EC2s to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: {
          "AWS": "arn:aws:iam::${var.s3_remote_account_id}:role/${var.s3_remote_role_name}"
        },
        Action: "sts:AssumeRole"
      }
    ]
  })
}

#attach permission policies to trust policy (role)
resource "aws_iam_role_policy_attachment" "role_policy_attachment_s3_cross_account" {
  count      = var.s3_cross_account_enabled ? 1 : 0
  role       = aws_iam_role.role_s3_cross_account[0].name
  policy_arn = aws_iam_policy.permission_policy_s3_cross_account[0].arn
}

#bucket policy
resource "aws_s3_bucket_policy" "bucket_policy_s3_cross_account" {
  bucket = aws_s3_bucket.bucket-test.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.s3_remote_account_id}:role/${var.s3_remote_role_name}"
        },
        Action = "s3:ListBucket",
        Resource = "arn:aws:s3:::${var.s3_local_bucket}",
        Condition = {
          StringEquals = {
            "aws:SourceVpce": "${var.s3_remote_gateway_endpoint_id}"
          }
        }
      },
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.s3_remote_account_id}:role/${var.s3_remote_role_name}"
        },
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject"
        ],
        Resource = "arn:aws:s3:::${var.s3_local_bucket}/${var.s3_local_folder}/*",
        Condition = {
          StringEquals = {
            "aws:SourceVpce": "${var.s3_remote_gateway_endpoint_id}"
          }
        }
      }
    ]
  })
}

###/Policies and roles to authorize cross-account access to S3 bucket from remote account
