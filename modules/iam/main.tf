resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = "Permissions to manage files in S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowObjectOperations"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_user" "this" {
  count = var.create_user ? 1 : 0
  name  = var.user_name
}

resource "aws_iam_user_policy_attachment" "this" {
  count      = var.create_user ? 1 : 0
  user       = aws_iam_user.this[0].name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_access_key" "this" {
  count = var.create_user ? 1 : 0
  user  = aws_iam_user.this[0].name
}
