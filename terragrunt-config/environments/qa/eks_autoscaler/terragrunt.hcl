include {
  path = find_in_parent_folders()
}
terraform {
  source = "../../src/3-eks-cluster-autoscaler"
}
inputs = {
  environment = "qa"
  aws_region = "us-east-2"
}