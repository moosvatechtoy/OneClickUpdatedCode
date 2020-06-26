# EKS Getting Started Guide Configuration

This is the full configuration from https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html

See that guide for additional information.

NOTE: This full configuration utilizes the [Terraform http provider](https://www.terraform.io/docs/providers/http/index.html) to call out to icanhazip.com to determine your local workstation external IP for easily configuring EC2 Security Group access to the Kubernetes master servers. Feel free to replace this as necessary.

»Prerequisites
The guide assumes some basic familiarity with Kubernetes and kubectl but does not assume any pre-existing deployment.

It also assumes that you are familiar with the usual Terraform plan/apply workflow. If you're new to Terraform itself, refer first to the Getting Started guide.

For this guide, you will need:

an AWS account,
a configured AWS CLI
AWS IAM Authenticator  --> will be installed as a part of cluster creation
kubectl --> will be installed as a part of cluster creation


By initializing the terraform, it will prompt for the below value to enter. Example values are provided in the description of each variable

``` list
bucket_name     --> Name of the existing bucket, where terraform state file to be stored.
path_to_key     --> path in the bucket where the state file is stored. *Ex: oneclick/statestore/terraform.tfstate*
access_key      --> Access key to connect to the AWS account.
secret_key      --> Secret key to connect to the AWS account.
cluster_name    --> Name of the eks cluster to be created.
region_name     --> Cluster to be created in which region *ex: us-east-1*
vpc_cidr_block  --> cidr block for vpc *ex: 10.0.0.0/16*
vpc_subnet      --> VPC subnet ranges, minimum two should be entered. *Ex: ["10.0.1.0/24", "10.0.2.0/24"]*
instance_types  --> Instance type associated with the EKS Node Group *Ex: ["t3.medium"]*. Currently, the EKS API only accepts a single value in the set.
desired_size    --> Desired number of worker nodes. Should be grater than 0
max_size     --> Maximum number of worker nodes. Should be grater than 0
min_size     --> Minimum number of worker nodes. Should be grater than 0 
```