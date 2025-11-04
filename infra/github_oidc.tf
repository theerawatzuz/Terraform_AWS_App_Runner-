resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}


locals {
  gh_repo = "theerawatzuz/Terraform_AWS_App_Runner-"  
}

data "aws_iam_policy_document" "gh_assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${local.gh_repo}:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "github_actions_apprunner" {
  name               = "github-actions-apprunner"
  assume_role_policy = data.aws_iam_policy_document.gh_assume_role.json
}

# 3) สิทธิ์ที่ Actions ต้องใช้: ECR (login/push) + App Runner (deploy)
data "aws_iam_policy_document" "gh_policy" {
  statement {
    sid     = "EcrAuth"
    effect  = "Allow"
    actions = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "EcrPushPull"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:DescribeRepositories",
      "ecr:ListImages"
    ]
    resources = [
      "arn:aws:ecr:${var.region}:${var.account_id}:repository/${var.ecr_repository_name}"
    ]
  }

  statement {
    sid    = "AppRunnerDeploy"
    effect = "Allow"
    actions = [
      "apprunner:StartDeployment",
      "apprunner:DescribeService",
      "apprunner:ListServices",
      "apprunner:ListOperations",
      "apprunner:UpdateService"
    ]
    resources = [
      # ให้แค่วิธีที่คุณใช้จริง ๆ ก็ได้ (บริการเดียว)
      aws_apprunner_service.app_service.arn
    ]
  }
}

resource "aws_iam_policy" "github_actions_apprunner" {
  name   = "github-actions-apprunner-policy"
  policy = data.aws_iam_policy_document.gh_policy.json
}

resource "aws_iam_role_policy_attachment" "gh_attach" {
  role       = aws_iam_role.github_actions_apprunner.name
  policy_arn = aws_iam_policy.github_actions_apprunner.arn
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions_apprunner.arn
}