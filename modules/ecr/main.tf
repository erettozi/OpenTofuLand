data "aws_caller_identity" "current" {}

module "ecr_app" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  repository_name                 = var.repository_name
  repository_image_tag_mutability = "MUTABLE"

  create_lifecycle_policy = true
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Remove pipeline test images",
        selection = {
          tagStatus = "tagged",
          tagPatternList = [
            "*-test"
          ],
          countType   = "sinceImagePushed",
          countUnit   = "days",
          countNumber = 7
        },
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2,
        description  = "Keep last X images",
        selection = {
          tagStatus   = "any",
          countType   = "imageCountMoreThan",
          countNumber = 60
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  repository_force_delete = true
}