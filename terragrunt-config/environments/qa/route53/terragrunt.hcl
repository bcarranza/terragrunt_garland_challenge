include {
  path = find_in_parent_folders()
}
terraform {
  source = "../../src/0-route53-hostedzone"
}
inputs = {
  enviroment = "qa"
  aws_region = "us-east-2"
  domain_name = "qa.k8s.managedkube.com"
}