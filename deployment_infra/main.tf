module "network" {
  source = "./network"
  enviroment_name = var.enviroment_name
}

module "machine" {
  source = "./machine"
  subnet_id = module.network.subnet_id
  enviroment_name = var.enviroment_name
}