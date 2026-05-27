resource "aws_ecr_repository" "ndtrepo" {
  name = "ndt-image-repo"
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
    }
}

resource "aws_ecr_lifecycle_policy" "cleanup_policy" {
  repository = aws_ecr_repository.ndtrepo.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description = "keep the 10 latest images"
	selection = {
          tagStatus = "any"
          countType = "imageCountMoreThan"
          countNumber = 10
          }
          action = {
            type = "expire"
            }
          }
        ]
     })
}
