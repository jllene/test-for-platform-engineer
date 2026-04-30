provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  version = "~> 4.21.0"
}

terraform {
  backend "s3" {
  }
}

module "s3" {
  source             = "./infra/s3"  
  bucket_alb_log     = var.bucket_alblog
  bucket_deployment  = var.bucket_deployment
}

module "vpc" {
  source             = "./infra/vpc"  
}

module "sg" {
  source             = "./infra/sg"  
  vpc_id             = module.vpc.vpc_id
}

module "alb" {
  source             = "./infra/alb"
  vpc_id             = module.vpc.vpc_id
  public_subnet_list = module.vpc.public_subnets
  alb_sg_id          = module.sg.alb_sg_id
  bucket_alblog      = var.bucket_alblog
}

module "redis" {
  source            = "./infra/redis"
  vpc_id            = module.vpc.vpc_id
  redis_subnet_list = module.vpc.private_subnets
  redis_sg          = module.sg.redis_sg_id
  redis_auth        = var.redis_auth
}

module "ecs" {
  source             = "./infra/ecs"
  redis_subnet_list = module.vpc.private_subnets
  redis_sg          = module.sg.web_sg_id
  image_uri         = var.image_uri
}
