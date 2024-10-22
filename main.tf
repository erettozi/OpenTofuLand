module "iam" {
  source = "./modules/iam"
}

module "vpc" {
  source = "./modules/vpc"
}

module "rds" {
  source = "./modules/rds"
}

module "ecr" {
  source = "./modules/ecr"
}

module "ecs" {
  source = "./modules/ecs"
}

module "static" {
  source = "./modules/static"
}

module "state" {
  source = "./modules/state"
}
