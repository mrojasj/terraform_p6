module "network" {
  source = "./modules/network"
  vpc_cidr_block = var.vpc_cidr_block
  snet_cidr_block_list = var.snet_cidr_block_list
}

module "vm" {
  source = "./modules/vm"
  keyName = var.keyName
  vpc_id = module.network.vpc_id
  subnet_id = module.network.subnet_ids[0]
}