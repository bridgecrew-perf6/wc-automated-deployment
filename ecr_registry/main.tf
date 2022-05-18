module "registry" {
  source = "./registry"
  enviroment_name = var.enviroment_name
}

resource "aws_ssm_parameter" "registry_url" {
  name  = "${var.enviroment_name}_ecr_registry_url"
  type  = "String"
  value = module.registry.repository_url
}

resource "aws_ssm_parameter" "registry_arn" {
  name  = "${var.enviroment_name}_ecr_registry_arn"
  type  = "String"
  value = module.registry.arn
}