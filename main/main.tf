


/*
module "api-gateway"{
    source = "../modules/api-gateway"

}
*/



/*
module "opensearch" {
    source = "../modules/opensearch"

    vpc_id          = module.vpc.vpc_id
    data_subnets    = module.vpc.data_subnets
    vpc_cidr        = module.vpc.vpc_cidr

    domain_name     = "${var.project}"
    engine_version  = "OpenSearch_2.11"
    instance_type   = "t3.small.search"
    instance_count  = 1
    
    master_user_name = "energy-pool"
}
*/


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