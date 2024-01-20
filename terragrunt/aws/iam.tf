data "aws_iam_policy_document" "service_principal" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "web" {
  name               = "${var.product_name}-web"
  assume_role_policy = data.aws_iam_policy_document.service_principal.json
}

data "aws_iam_policy" "lambda_insights" {
  name = "CloudWatchLambdaInsightsExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "lambda_insights" {
  role       = aws_iam_role.web.name
  policy_arn = data.aws_iam_policy.lambda_insights.arn
}

data "aws_iam_policy_document" "web_policies" {

  statement {

    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:log-group:*"
    ]
  }

  statement {

    effect = "Allow"

    actions = [
      "ecr:GetDownloadUrlForlayer",
      "ecr:BatchGetImage"
    ]
    resources = [
      aws_ecr_repository.web.arn
    ]
  }

}

resource "aws_iam_policy" "web" {
  name   = "${var.product_name}-web"
  path   = "/"
  policy = data.aws_iam_policy_document.web_policies.json
}

resource "aws_iam_role_policy_attachment" "web" {
  role       = aws_iam_role.web.name
  policy_arn = aws_iam_policy.web.arn
}
