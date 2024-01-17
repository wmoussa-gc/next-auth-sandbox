resource "aws_lambda_function" "this" {
  filename         = data.archive_file.function_package.output_path
  function_name    = "next-js-website"
  role             = aws_iam_role.this.arn
  handler          = "run.sh"
  runtime          = "nodejs16.x"
  architectures    = ["x86_64"]
  layers           = ["arn:aws:lambda:eu-west-1:753240598075:layer:LambdaAdapterLayerX86:7"]
  memory_size      = 3008
  timeout          = 30
  source_code_hash = data.archive_file.function_package.output_base64sha256
  environment {
    variables = {
      "AWS_LAMBDA_EXEC_WRAPPER" = "/opt/bootstrap",
      "RUST_LOG"                = "info",
      "PORT"                    = "8000",
      "NODE_ENV"                = "production"
    }
  }
}

resource "aws_lambda_function_url" "this" {
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"
}
