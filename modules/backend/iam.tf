data "aws_iam_policy_document" "policy_document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]
    resources = [
      aws_ecr_repository.repository.arn
    ]
  }
}

resource "aws_iam_user_policy" "policy" {
  name = "github_actions_backend_deploy_policy"
  user = "github_actions_deploy"

  policy = data.aws_iam_policy_document.policy_document.json
}
