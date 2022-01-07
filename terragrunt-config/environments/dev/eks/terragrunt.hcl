terraform {
  source =
    "../../src/2-eks"
}
inputs = {
  enviroment = "dev"
  aws_region = "us-east-1"
  cluster_version="1.20"
  cluster_endpoint_public_access_cidrs = [
    "0.0.0.0/0",
    "1.1.1.1/32",
  ]
  cluster_endpoint_private_access_cidrs= [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
    "100.64.0.0/16",
  ]
  node_version = "1.20"
  disk_size=20
  desired_capacity = 2
  max_capacity = 4
  min_capacity = 1
  instance_types = ["t3.small"]
}