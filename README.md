# Terragrunt Garland Challange
    This repo has code about garland's challange, following is a detail of the requirement.

## Requirements:
    Then this is a perfect technical test.  We are using Terragrunt here and you will have to learn that anyways.  This test is here to assess a few things:
    - How well you can pick up and learn a new tech
    - How well you can implement something new
    - How well you communicate
    
    The Task:
    Convert this to a terragrunt format:  https://github.com/ManagedKube/kubernetes-ops/blob/main/terraform-environments/aws/dev/25-eks-cluster-autoscaler/main.tf
    You can mock most of it out and i dont need actual working code but I do need something in the Terragrunt format that resembles a working config
    Leverage me if you have any further questions or you are stuck on something.  Ask questions here.  If no questions are asked, im assuming you understand everything and will be able to complete this task
    
    What im assessing this on:
      - If you understand the tech
      - If you can complete the task. 
      - Full completion of the task is not 100% necessary, im also looking for how you are able to unblock yourself and on tasks by either asking questions, leveraging other members in the team, or googling
      - That we can work in a remote fashion.  This means that we can communicate over Slack, huddle, zoom, etc.  That we can work in an async fashion where we both dont need to be online at the same time.  That you can coordinate and get time when we do need an in person meeting.
    
    What you should deliever:
    A file.  This file will be similar to the original one but in a Terragrunt format.  It will be similar to the length as well.
    Post it here


1. i got a fork or copy from file repo in terraform old format, you could see [here](/terragrunt_garland_challenge/terraform.old.format)

## Terragrunt 
![](img/terragrunt_logo.png)
Terragrunt is a thin wrapper that provides extra tools for keeping your configurations DRY, working with multiple Terraform modules, and managing remote state.
In summary Define Terraform code once, no matter how many environments you have.
<br />
source: https://terragrunt.gruntwork.io/


## What is the problem and the Solution?
In my own words, i consider that for create multiples enviroments as dev, qa and prod; when you are using terraform , you need to create once file for every enviroment. for example.
<br />
![](img/terraform_architecture.png)
<br />
Terragrunt solves it. something like this
<br />
![](img/terragrunt_modules.png)

1. first, Install terragrunt (mac os)
   >➜ ✗ brew install terragrunt

2. In adition , i created an organization in my own account of terraform cloud with name managekube1 (managekube already exits)
<br />
![](img/terraform_cloud_org.png)

1. Futhermore, 
To understand how I could implement terragrunt, I first set up a traditional terraform cloud environment to validate that my traditional terraform files worked well; this being a set of folders each with its own main.tf; to ensure that the required file works correctly; I needed to connect 
with terraform cloud and aws credentials (personal account); from here it is evident the problem, it is necessary to configure workspaces previously and hardcode it, the environment variables are managed in a group for each workspace, so it is usually a headache.
In this step run each of the following resource groups

- route 53
  ![](img/terraform_old/route53_bash_result.png)
  ![](img/terraform_old/route53_console_result.png)
- vpc
  ![](img/terraform_old/vpc_bash_result.png)
  ![](img/terraform_old/vpc_console_result.png)
- eks
  ![](img/terraform_old/eks_bash_result.png)
  ![](img/terraform_old/eks_console_result.png)
- eks autoscaler
  ![](img/terraform_old/eks_autoscaler_bash.png)
  ![](img/terraform_old/eks_autoscaler_console.png)

  in the right order, since there is resource dependency; resulting in successful states in terraform cloud
  ![](img/terraform_old/workspace_terraform_cloud_result.png)

4. And finally, I implemented terragrunt (note: the repo given in the 
  requirement already had terragrunt implemented for the whole 
  solution, however I tried to do it on my own for the required file).
  But if it is necessary to indicate if I understood how it was implemented in original repo, you can contact me

  - Terragrunt was configured in folder (./terragrunt-config)
  - A folder called src with the main terraform (tf) files was created
  - ![](img/terragrunt/terragrunt_src.png)
  - The model used in terragrunt was "Promote immutable, versioned Terraform modules across environments". Here is a reference image in source: https://terragrunt.gruntwork.io/docs/getting-started/quick-start/
  - ![](img/terragrunt/terragrunt_model_reference.png)
  - In our own model it looks like this
  - ![](img/terragrunt/terragrunt_own_model.png)
  - How terragrunt works?: 
    - A single set of terraform master files
    - Each file must contain input variables to customize our deployment as much as possible.
    - In case of the file required by Garland Kan, implement only 2 input variables: environment and region. But in the previous dependent files we can observe more configurable elements such as cluster size, ec2 size, etc.
    - Additionally, concatenate the environment to the terraform backend workspace, so that the states do not overwrite themselves.
    - ![](img/terragrunt/terragrunt_file_tf_1.png)
    - ![](img/terragrunt/terragrunt_file_tf_2.png)
    - Folders could be sorted by environment, stack or resource (depends on the case ). example (./enviroments/dev/eks_autoscaler/terragrunt.hcl)
    - Terragrunt.hcl files contain the set of custom input variables for each environment. In the case of the request file, it looks like this in dev:
    - ![](img/terragrunt/terragrunt_eksautoscaler_hcl.png)
    - Below is a table of the values that were configured per environment for the complete solution, including vpc, route53, eks and eks_autoscaler.
      | Resource  |  Parameter  | Dev  | Qa  | Prod  |
      |---|---|---|---|---|
      |  Route53  | enviroment  |  dev | qa  | prod  |
      |  Route53  |  aws_region |  us-east-1 | us-east-2  | us-west-1  |
      |  Route53  | domain_name  |  dev.k8s.managedkube.com | qa.k8s.managedkube.com  |  prod.k8s.managedkube.com |
      |  VPC  | azs  | "us-east-1a", "us-east-1c", "us-east-1d"  |  "us-east-2a", "us-east-2b", "us-east-2c" | "us-west-1a", "us-west-1b", "us-west-1c"  |
      |  VPC  |  vpc_cidr | "10.0.0.0/16"  | "10.0.0.0/16"  | "10.0.0.0/16"  |
      |  VPC  | private_subnets  |  "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" | "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"  |  "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" |
      |  VPC  | public_subnets  | "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"  |  "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24" |  "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24" |
      |  EKS  |  cluster_version | 1.20  | 1.20  | 1.20  |
      |  EKS  | cluster_endpoint_public_access_cidrs  |  "0.0.0.0/0","1.1.1.1/32"  | "0.0.0.0/0","1.1.1.1/32"  |  "0.0.0.0/0","1.1.1.1/32" |
      |  EKS  | cluster_endpoint_private_access_cidrs  | "10.0.0.0/8","172.16.0.0/12","192.168.0.0/16","100.64.0.0/16"  | "10.0.0.0/8","172.16.0.0/12","192.168.0.0/16","100.64.0.0/16"  |  "10.0.0.0/8","172.16.0.0/12","192.168.0.0/16","100.64.0.0/16" |
      |  EKS  |  node_version |  1.20 |  1.20 |  1.20 |
      |  EKS  | disk_size  |  20gb | 40gb  | 80gb  |
      |  EKS  | desired_capacity  |  2 | 2 |  2 |
      |  EKS  |  max_capacity |  2 | 4  |  8 |
      |  EKS  | min_capacity  |  1 | 2  | 3  |
      |  EKS  | instance_types  | t3.small  | t3.medium  | t3.large  |

    - All of the above will give us greater flexibility in the deployment of our 3 important environments in a more orderly and simple way. 
## Cooming Soon, Work under construction (we have some issues with terragrunt!!!)
<img src="img/terragrunt/underconstruction.png" alt="drawing" width="200"/>
