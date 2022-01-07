terraform {
  source =
    "../../src/3-eks-cluster-autoscaler"
}
inputs = {
  environment = "prod"
  aws_region = "us-west-1"
}