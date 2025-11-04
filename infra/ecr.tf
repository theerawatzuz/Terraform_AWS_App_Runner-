
resource "aws_ecr_repository" "app_repo" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"

  # optional: แนะนำเปิดสแกน + ระบุ encryption
  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Project = var.project_name
  }
}

resource "aws_ecr_lifecycle_policy" "retention" {
  repository = aws_ecr_repository.app_repo.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1,
      description  = "Keep last 10 images",
      selection = {
        tagStatus   = "any",
        countType   = "imageCountMoreThan",
        countNumber = 10
      },
      action = { type = "expire" }
    }]
  })
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}