# # complete.tf

# provider "aws" {
#   region = var.region
# }

# module "vpc" {
#   source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.13.0"
#   namespace  = var.namespace
#   stage      = var.stage
#   name       = var.name
#   cidr_block = "10.0.0.0/16"
# }

# module "subnets" {
#   source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.19.0"
#   availability_zones   = var.availability_zones
#   namespace            = var.namespace
#   stage                = var.stage
#   vpc_id               = module.vpc.vpc_id
#   igw_id               = module.vpc.igw_id
#   cidr_block           = module.vpc.vpc_cidr_block
#   nat_gateway_enabled  = false
#   nat_instance_enabled = true
# }

# module "storage_gateway" {
#   source = "../.."

#   namespace  = var.namespace
#   stage      = var.stage
#   bucket_arn = "TODO"
#   subnet_id  = module.subnets.public_subnet_ids[0]
#   vpc_id     = module.network.vpc_id
# }
