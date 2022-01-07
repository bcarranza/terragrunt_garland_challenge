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


1. i got a fork or copy from file repo in terraform old format, you could see [here](/terragrunt_garland_challenge/terraform.old.format/main.tf)

## Terragrunt 
Terragrunt is a thin wrapper that provides extra tools for keeping your configurations DRY, working with multiple Terraform modules, and managing remote state.
In summary Define Terraform code once, no matter how many environments you have.
<br />
![](/img/terragrunt_enviroment.png)
source: https://terragrunt.gruntwork.io/


## What is the problem and the Solution?
In my own words, i consider that for create multiples enviroments as dev, qa and prod; when you are using terraform , you need to create once file for every enviroment. for example.
<br />
![](/img/terraform_architecture.png)
<br />
Terragrunt solves it. something like this
<br />
![](/img/terragrunt_modules.png)

1. first, Install terragrunt (mac os)
   >➜ ✗ brew install terragrunt

2. In adition , i created an organization in my own account of terraform cloud with name managekube1 (managekube already exits)
<br />
![](/img/terraform_cloud_org.png)

3. Futhermore, (explain about terraform old format)