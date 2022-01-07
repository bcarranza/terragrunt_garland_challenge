terraform {
  source =
    "../../src/0-route53-hostedzone"
}
inputs = {
  enviroment = "qa"
  aws_region = "us-west-1"
  domain_name = "prod.k8s.managedkube.com"
}