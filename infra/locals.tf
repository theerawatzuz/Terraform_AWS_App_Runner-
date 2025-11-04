locals {
  image_uri = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repository_name}:${var.image_tag}"
}