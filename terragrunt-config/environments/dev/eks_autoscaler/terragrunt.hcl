/*BC: the following functions help to access parent folders, to get to the main terraform files*/
include {
  path = find_in_parent_folders()
}
/* BC: In this line you can reference either the direct folder of your terraform files, or github submodules. */
terraform {
  source ="../../src/3-eks-cluster-autoscaler". 
}
/*BC: These variables serve as input parameters for a development/qa/production environment, for more details you can read the readme with the different values.*/
inputs = {
  environment = "dev"
  aws_region = "us-east-1"
  organization_name = "managedkube1"
  workspace_name = "eks_autoscaler_workspace"
  cluster_name = "eks-dev-garlandchallange"
}