terraform {
  source =
    "../../src/0-route53-hostedzone"
}
inputs = {
  enviroment = "dev"
  aws_region = "us-east-1"
  domain_name = "dev.k8s.managedkube.com"
}