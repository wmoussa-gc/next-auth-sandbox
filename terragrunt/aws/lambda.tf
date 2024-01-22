resource "aws_lambda_function" "web" {
  function_name = "next_lambda_function"
  role          = aws_iam_role.web.arn
  package_type  = "Image"
  memory_size   = 1024
  timeout       = 30
  image_uri     = "${aws_ecr_repository.web.repository_url}:latest"

  environment {
    variables = {
      "AWS_LAMBDA_EXEC_WRAPPER" = "/opt/bootstrap",
      "RUST_LOG"                = "info",
      "PORT"                    = "8000",
      "NODE_ENV"                = "production"
    }
  }
}

resource "aws_lambda_function_url" "web" {
  function_name      = aws_lambda_function.web.function_name
  authorization_type = "NONE"
}
