variable "enviroment_name"  { }

resource "aws_ecr_repository" "primary" {
  name                 = var.enviroment_name
  image_tag_mutability = "MUTABLE"
}

output "repository_url" {
  value = aws_ecr_repository.primary.repository_url
}

output "arn" {
  value = aws_ecr_repository.primary.arn
}