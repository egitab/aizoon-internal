data "aws_caller_identity" "current" {}

######### Policies and roles to authorize cross-account access to S3 bucket from remote account

# test using aizoon account
#permission policy
resource "aws_iam_policy" "permission_policy_s3_test_cross_account" {
  count    = var.s3_test_cross_account_enabled ? 1 : 0
  name     = local.s3_test_permission_policy_name
  policy   = jsonencode({
    Version  = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:ListBucketMultipartUploads",
          "s3:ListBucketVersions",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource = "arn:aws:s3:::${var.s3_test_local_bucket}"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:GetObjectTagging",
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectAttributes",
					"s3:GetObjectVersionAttributes",
					"s3:GetObjectLegalHold",
					"s3:GetObjectRetention",
					"s3:PutObject",
					"s3:PutObjectAcl",
					"s3:PutObjectTagging",
					"s3:PutObjectVersionTagging",
					"s3:PutObjectLegalHold",
					"s3:PutObjectRetention",
					"s3:DeleteObject",
					"s3:DeleteObjectVersion",
					"s3:DeleteObjectTagging",
					"s3:DeleteObjectVersionTagging",
					"s3:AbortMultipartUpload",
					"s3:ListMultipartUploadParts",
					"s3:ObjectOwnerOverrideToBucketOwner"
        ],
        Resource = "arn:aws:s3:::${var.s3_test_local_bucket}/${var.s3_test_local_folder}/*"
      }
    ]
  })
}

#before provisioning below resources, please check the role ${var.s3_test_remote_role_name} exists on remote account

#trust policy (role)
resource "aws_iam_role" "role_s3_test_cross_account" {
  count    = var.s3_test_cross_account_enabled ? 1 : 0
  name     = "${local.s3_test_role_name}"

  # Allow remote roles to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = [
            "arn:aws:iam::${var.s3_test_remote_account_id}:role/${var.s3_test_remote_role_name}",
            "arn:aws:iam::${var.s3_test_remote_account_id}:role/role-emeahub-xf-prod-automation",
            "arn:aws:iam::899011411636:user/user-emeahub-xf-prod-automation-aid5hy7k"
          ]
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#attach permission policies to trust policy (role)
resource "aws_iam_role_policy_attachment" "role_policy_attachment_s3_test_cross_account" {
  count      = var.s3_test_cross_account_enabled ? 1 : 0
  role       = aws_iam_role.role_s3_test_cross_account[0].name
  policy_arn = aws_iam_policy.permission_policy_s3_test_cross_account[0].arn
}

#bucket policy
resource "aws_s3_bucket_policy" "bucket_policy_s3_test_cross_account" {
  bucket = aws_s3_bucket.bucket-test-2.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = [
            "arn:aws:iam::${var.s3_test_remote_account_id}:role/${var.s3_test_remote_role_name}",
            "arn:aws:iam::${var.s3_test_remote_account_id}:role/role-emeahub-xf-prod-automation",
            "arn:aws:iam::899011411636:user/user-emeahub-xf-prod-automation-aid5hy7k"
          ]
        },
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:ListBucketMultipartUploads",
          "s3:ListBucketVersions"
        ],
        Resource = "arn:aws:s3:::${var.s3_test_local_bucket}",
        Condition = {
          StringEquals = {
            "aws:SourceVpce": "${var.s3_test_remote_gateway_endpoint_id}"
          }
        }
      },
      {
        Effect = "Allow",
        Principal = {
          AWS = [
            "arn:aws:iam::${var.s3_test_remote_account_id}:role/${var.s3_test_remote_role_name}",
            "arn:aws:iam::${var.s3_test_remote_account_id}:role/role-emeahub-xf-prod-automation",
            "arn:aws:iam::899011411636:user/user-emeahub-xf-prod-automation-aid5hy7k"
          ]
        },
        Action = [
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:GetObjectTagging",
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectAttributes",
          "s3:GetObjectVersionAttributes",
          "s3:GetObjectLegalHold",
          "s3:GetObjectRetention",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:PutObjectTagging",
          "s3:PutObjectVersionTagging",
          "s3:PutObjectLegalHold",
          "s3:PutObjectRetention",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:DeleteObjectTagging",
          "s3:DeleteObjectVersionTagging",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ],
        Resource = "arn:aws:s3:::${var.s3_test_local_bucket}/${var.s3_test_local_folder}/*",
        Condition = {
          StringEquals = {
            "aws:SourceVpce": "${var.s3_test_remote_gateway_endpoint_id}"
          }
        }
      }
    ]
  })
}
# /test using aizoon account

#gdrp
#permission policy test
resource "aws_iam_policy" "permission_policy_s3_cross_account" {
  count    = var.s3_cross_account_enabled ? 1 : 0
  name     = local.s3_permission_policy_name
  policy   = jsonencode({
    Version  = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:ListBucketMultipartUploads",
          "s3:ListBucketVersions",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource: [
          "arn:aws:s3:::${var.s3_local_bucket}"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:GetObjectTagging",
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectAttributes",
					"s3:GetObjectVersionAttributes",
					"s3:GetObjectLegalHold",
					"s3:GetObjectRetention",
					"s3:PutObject",
					"s3:PutObjectAcl",
					"s3:PutObjectTagging",
					"s3:PutObjectVersionTagging",
					"s3:PutObjectLegalHold",
					"s3:PutObjectRetention",
					"s3:DeleteObject",
					"s3:DeleteObjectVersion",
					"s3:DeleteObjectTagging",
					"s3:DeleteObjectVersionTagging",
					"s3:AbortMultipartUpload",
					"s3:ListMultipartUploadParts",
					"s3:ObjectOwnerOverrideToBucketOwner"
        ],
        Resource: [
          "arn:aws:s3:::${var.s3_local_bucket}/${var.s3_local_folder}/*"
        ]
      }
    ]
  })
}
#permission policy mockup-prod
resource "aws_iam_policy" "permission_policy_s3_mockup_prod_cross_account" {
  count    = var.s3_cross_account_enabled ? 1 : 0
  name     = local.s3_mockup_prod_permission_policy_name
  policy   = jsonencode({
    Version  = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:ListBucketMultipartUploads",
          "s3:ListBucketVersions",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource: [
          "arn:aws:s3:::${var.s3_mockup_prod_local_bucket}"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:GetObjectTagging",
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectAttributes",
					"s3:GetObjectVersionAttributes",
					"s3:GetObjectLegalHold",
					"s3:GetObjectRetention",
					"s3:PutObject",
					"s3:PutObjectAcl",
					"s3:PutObjectTagging",
					"s3:PutObjectVersionTagging",
					"s3:PutObjectLegalHold",
					"s3:PutObjectRetention",
					"s3:DeleteObject",
					"s3:DeleteObjectVersion",
					"s3:DeleteObjectTagging",
					"s3:DeleteObjectVersionTagging",
					"s3:AbortMultipartUpload",
					"s3:ListMultipartUploadParts",
					"s3:ObjectOwnerOverrideToBucketOwner"
        ],
        Resource: [
          "arn:aws:s3:::${var.s3_mockup_prod_local_bucket}/${var.s3_mockup_prod_local_folder}/*"
        ]
      }
    ]
  })
}

#before provisioning below resources, please check the role ${var.s3_remote_role_name} exists on remote account

#trust policy 1 (role)
resource "aws_iam_role" "role_s3_cross_account" {
  count    = var.s3_cross_account_enabled ? 1 : 0
  name     = "${local.s3_role_name}"
  #permissions_boundary = "${var.ec2_role_01_pbnd_arn}"

  # Allow remote roles to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = [
            "arn:aws:iam::${var.s3_test_remote_account_id}:role/${var.s3_remote_role_name}",
            "arn:aws:iam::${var.s3_test_remote_account_id}:role/role-emeahub-xf-prod-automation",
            "arn:aws:iam::899011411636:user/user-emeahub-xf-prod-automation-aid5hy7k"
          ]
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#trust policy 2 (role) - mockup-prod
resource "aws_iam_role" "role_s3_mockup_prod_cross_account" {
  count    = var.s3_cross_account_enabled ? 1 : 0
  name     = "${local.s3_mockup_prod_role_name}"
  #permissions_boundary = "${var.ec2_role_01_pbnd_arn}"

  # Allow remote roles to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = [
            #same remote roles as 'trust policy 1' are permitted to assume this role
            "arn:aws:iam::${var.s3_test_remote_account_id}:role/${var.s3_test_remote_role_name}",
            "arn:aws:iam::${var.s3_test_remote_account_id}:role/role-emeahub-xf-prod-automation",
            "arn:aws:iam::899011411636:user/user-emeahub-xf-prod-automation-aid5hy7k"
          ]
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#attach permission policy 1 to trust policy 1 (role)
resource "aws_iam_role_policy_attachment" "role_policy_attachment_s3_cross_account" {
  count      = var.s3_cross_account_enabled ? 1 : 0
  role       = aws_iam_role.role_s3_cross_account[0].name
  policy_arn = aws_iam_policy.permission_policy_s3_cross_account[0].arn
}

#attach permission policy 2 (mockup-prod) to trust policy 2 (role)
resource "aws_iam_role_policy_attachment" "role_policy_attachment_s3_mockup_prod_cross_account" {
  count      = var.s3_cross_account_enabled ? 1 : 0
  role       = aws_iam_role.role_s3_mockup_prod_cross_account[0].name
  policy_arn = aws_iam_policy.permission_policy_s3_mockup_prod_cross_account[0].arn
}

#bucket policy 1
resource "aws_s3_bucket_policy" "bucket_policy_s3_cross_account" {
  bucket = aws_s3_bucket.bucket-test.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = [
            "arn:aws:iam::${var.s3_remote_account_id}:role/${var.s3_remote_role_name}",
            "arn:aws:iam::${var.s3_test_remote_account_id}:role/role-emeahub-xf-prod-automation",
            "arn:aws:iam::899011411636:user/user-emeahub-xf-prod-automation-aid5hy7k"
          ]
        },
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:ListBucketMultipartUploads",
          "s3:ListBucketVersions"
        ],
        Resource: [
          "arn:aws:s3:::${var.s3_local_bucket}"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceVpce": "${var.s3_remote_gateway_endpoint_id}"
          }
        }
      },
      {
        Effect = "Allow",
        Principal = {
          AWS = [
            "arn:aws:iam::${var.s3_remote_account_id}:role/${var.s3_remote_role_name}",
            "arn:aws:iam::${var.s3_test_remote_account_id}:role/role-emeahub-xf-prod-automation",
            "arn:aws:iam::899011411636:user/user-emeahub-xf-prod-automation-aid5hy7k"
          ]
        },
        Action = [
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:GetObjectTagging",
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectAttributes",
          "s3:GetObjectVersionAttributes",
          "s3:GetObjectLegalHold",
          "s3:GetObjectRetention",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:PutObjectTagging",
          "s3:PutObjectVersionTagging",
          "s3:PutObjectLegalHold",
          "s3:PutObjectRetention",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:DeleteObjectTagging",
          "s3:DeleteObjectVersionTagging",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ],
        Resource: [
          "arn:aws:s3:::${var.s3_local_bucket}/${var.s3_local_folder}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceVpce": "${var.s3_remote_gateway_endpoint_id}"
          }
        }
      }
    ]
  })
}

#bucket policy 2 (mockup-prod)
resource "aws_s3_bucket_policy" "bucket_policy_s3_mockup_prod_cross_account" {
  bucket = aws_s3_bucket.bucket-mockup-prod.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = [
            "arn:aws:iam::${var.s3_remote_account_id}:role/${var.s3_remote_role_name}",
            "arn:aws:iam::${var.s3_test_remote_account_id}:role/role-emeahub-xf-prod-automation",
            "arn:aws:iam::899011411636:user/user-emeahub-xf-prod-automation-aid5hy7k"
          ]
        },
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:ListBucketMultipartUploads",
          "s3:ListBucketVersions"
        ],
        Resource: [
          "arn:aws:s3:::${var.s3_mockup_prod_local_bucket}"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceVpce": "${var.s3_remote_gateway_endpoint_id}"
          }
        }
      },
      {
        Effect = "Allow",
        Principal = {
          AWS = [
            "arn:aws:iam::${var.s3_remote_account_id}:role/${var.s3_remote_role_name}",
            "arn:aws:iam::${var.s3_test_remote_account_id}:role/role-emeahub-xf-prod-automation",
            "arn:aws:iam::899011411636:user/user-emeahub-xf-prod-automation-aid5hy7k"
          ]
        },
        Action = [
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:GetObjectTagging",
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectAttributes",
          "s3:GetObjectVersionAttributes",
          "s3:GetObjectLegalHold",
          "s3:GetObjectRetention",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:PutObjectTagging",
          "s3:PutObjectVersionTagging",
          "s3:PutObjectLegalHold",
          "s3:PutObjectRetention",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:DeleteObjectTagging",
          "s3:DeleteObjectVersionTagging",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ],
        Resource: [
          "arn:aws:s3:::${var.s3_mockup_prod_local_bucket}/${var.s3_mockup_prod_local_folder}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceVpce": "${var.s3_remote_gateway_endpoint_id}"
          }
        }
      }
    ]
  })
}
#/gdrp

#########/Policies and roles to authorize cross-account access to S3 bucket from remote account
