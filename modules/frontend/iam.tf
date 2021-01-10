resource "aws_iam_user" "github_actions_deploy" {
  name          = "github_actions_deploy"
  force_destroy = true
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "policy_document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
    ]
    resources = [
      aws_s3_bucket.s3_bucket.arn,
      "${aws_s3_bucket.s3_bucket.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "cloudfront:GetDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:CreateInvalidation",
      "cloudfront:ListInvalidations",
      "cloudfront:GetInvalidation",
    ]
    resources = [
      aws_cloudfront_distribution.cloudfront_distribution.arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "cloudfront:ListDistributions",
      "cloudfront:ListStreamingDistributions",
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParametersByPath",
    ]
    resources = [
      "arn:aws:ssm:ap-northeast-1:${data.aws_caller_identity.current.account_id}:parameter/cognito"
    ]
  }
}

resource "aws_iam_user_policy" "policy" {
  name = "github_actions_deploy_policy"
  user = aws_iam_user.github_actions_deploy.name

  policy = data.aws_iam_policy_document.policy_document.json
}
