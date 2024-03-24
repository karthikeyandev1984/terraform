module "vpc" {
  source = "./modules/vpc"
  environment  = var.environment
  vpc_cidr = var.vpc_cidr
  public_subnets_cidr = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  region = var.region
  availability_zones  = var.availability_zones
}

module "eks_dev" {
  source = "./modules/eks"
  private_subnet_id = module.vpc.private_subnet_id
  cluster_name = var.cluster_name

}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}
