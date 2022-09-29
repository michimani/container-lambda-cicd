resource "aws_lambda_function" "container_lambda_function" {
  function_name = "container-lambda-function"
  role          = aws_iam_role.role_for_lambda.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.container_lambda_repository.repository_url}:latest"
  timeout       = 10
  memory_size   = 128
  environment {
    variables = {
      "ENV" = "prd"
    }
  }
}

resource "aws_iam_role" "role_for_lambda" {
  name = "container-lambda-function-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })

}

resource "aws_iam_policy" "policy_for_function" {
  name = "container-lambda-function-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "policy_attachment_for_function_role" {
  name = "policy-attachment-for-container-lambda-function-role"

  roles = [
    aws_iam_role.role_for_lambda.name
  ]

  policy_arn = aws_iam_policy.policy_for_function.arn
}



resource "aws_lambda_function" "container_lambda_function_dev" {
  function_name = "container-lambda-function-dev"
  role          = aws_iam_role.role_for_lambda.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.container_lambda_repository.repository_url}:dev"
  timeout       = 10
  memory_size   = 128
  environment {
    variables = {
      "ENV" = "dev"
    }
  }
}
