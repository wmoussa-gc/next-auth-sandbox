resource "aws_ecr_repository" "web" {

  name                 = "${var.product_name}/web"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
