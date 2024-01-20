resource "aws_ecr_repository" "web" {
  # checkov:skip=CKV_AWS_51:The :latest tag is used in Staging
  # checkov:skip=CKV_AWS_136: ECR encryption with default KMS key is acceptable

  name                 = "${var.product_name}/web"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
