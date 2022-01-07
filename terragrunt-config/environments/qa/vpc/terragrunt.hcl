include {
  path = find_in_parent_folders()
}
terraform {
  source ="../../src/1-vpc"
}
inputs = {
  environment = "qa"
  aws_region = "us-east-2"
  azs = ["us-east-2a", "us-east-2b", "us-east-2c"]
  vpc_cidr = "10.0.0.0/16" 
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}