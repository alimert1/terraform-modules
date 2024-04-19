module "vpc" {
    source = "../modules/vpc"
    env = var.env
    project = "${var.project}-${var.env}"
    vpc_block = "10.134.0.0/16"
    region = var.region

    public-subnet-map = [{ name = "${var.env}-Public-1a", az = "${var.region}a", cidr = "10.134.0.0/24", rt_name =  "${var.env}-Public"},
                       { name = "${var.env}-Public-1b", az = "${var.region}b", cidr = "10.134.1.0/24" }]

    private-subnet-map = [{ name = "${var.env}-Private-1a", az = "${var.region}a", cidr = "10.134.10.0/24", rt_name =  "${var.env}-Private" },
                       { name = "${var.env}-Private-1b", az = "${var.region}b", cidr = "10.134.11.0/24" }]

    data-subnet-map = [{ name = "${var.env}-Data-1a", az = "${var.region}a" , cidr = "10.134.20.0/24", rt_name =  "${var.env}-Data"},
                       { name = "${var.env}-Data-1b" , az = "${var.region}b", cidr = "10.134.21.0/24"}]

    ecs-subnet-map = [{ name = "${var.env}-ecs-1a", az = "${var.region}a" , cidr = "10.134.30.0/24", rt_name =  "${var.env}-ecs"},
                       { name = "${var.env}-ecs-1b" , az = "${var.region}b", cidr = "10.134.31.0/24"}]
}
module "ecs" {  
    source = "../modules/ecs"

    vpc_id             = module.vpc.vpc_id

    ecs_service_subnets = module.vpc.ecs_service_subnets

    public_subnets     = module.vpc.public_subnets
    private_subnets    = module.vpc.data_subnets
 
    ecr_image          = "992382571144.dkr.ecr.eu-central-1.amazonaws.com/todo-list:latest"
    project            = "${var.project}-${var.env}"
}


module "waf" {
  source = "../modules/waf"
  
  load_balancer_arn = module.load-balancer.load_balancer_arn
}

module "load-balancer" {
  source          = "../modules/load-balancer"
  
  project         = "${var.project}-${var.env}"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  domain          = ["aws-test.domain.com"]

}

module "s3" {
  source = "../modules/s3"
}


module "vpn" {
  source = "../modules/vpn"

  instance_type  = "t2.small"
  project        = "${var.project}-${var.env}"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}


