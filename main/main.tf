#cluster_name            = "${var.project}-${var.environment}"
module "vpc" {
  source = "../modules/vpc"

  project   = "${var.project}-${var.environment}"
  vpc_block = "10.0.0.0/16"
  region    = var.region


  public-subnet-map = [{ name = "${var.project}-${var.environment}-Public-1a", az = "${var.region}a", cidr = "10.0.10.0/24" },
  { name = "${var.project}-${var.environment}-Public-1b", az = "${var.region}b", cidr = "10.0.11.0/24" }]


  private-subnet-map = [{ name = "${var.project}-${var.environment}-Private-1a", az = "${var.region}a", cidr = "10.0.30.0/24" },
  { name = "${var.project}-${var.environment}-Private-1b", az = "${var.region}b", cidr = "10.0.31.0/24" }]

  data-subnet-map = [{ name = "${var.project}-${var.environment}-Data-1a", az = "${var.region}a", cidr = "10.0.40.0/24" },
  { name = "${var.project}-${var.environment}-Data-1b", az = "${var.region}b", cidr = "10.0.41.0/24" }]
}
