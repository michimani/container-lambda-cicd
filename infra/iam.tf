# OIDC Provider
resource "aws_iam_openid_connect_provider" "github_actiohns_provider" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

resource "aws_iam_role" "iam_role_for_github_actions" {
  name = "gha-role-for-container-lambda"
  path = "/demo/"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : "repo:michimani/container-lambda-cicd:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "iam_policy_for_github_actions" {
  name = "gha-policy-for-container-lambda"
  path = "/demo/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:*"
        ]
        Effect   = "Allow",
        Resource = aws_ecr_repository.container_lambda_repository.arn
      },
      {
        Action = [
          "lambda:UpdateFunctionCode",
          "lambda:Get*"
        ],
        Effect   = "Allow",
        Resource = aws_lambda_function.container_lambda_function.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy_to_role" {
  role       = regex("[\\w|-]+$", aws_iam_role.iam_role_for_github_actions.arn)
  policy_arn = aws_iam_policy.iam_policy_for_github_actions.arn
}

output "github-actions-role" {
  value = aws_iam_role.iam_role_for_github_actions.arn
}
