module "network" {
  source = "./modules/network"
}

module "server" {
  source           = "./modules/server"
  vpc_id           = module.network.vpc_id
  public_subnet_id = module.network.public_subnet_id
}
