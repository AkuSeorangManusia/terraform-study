# andimsum's AWS Infrastructure

AWS Terraform configuration for my things and study purposes

## Structure
```bash                                               
                                                   
  ┌─────────────────────────────────────────────────┐ 
  │ VPC                                             │ 
  │ ┌─────────────────────────────────────────────┐ │ 
  │ │               Public Subnet                 │ │ 
  │ │       ┌────────────────────────────┐        │ │ 
  │ │       │ ec2-edge                   │        │ │ 
  │ │       │ nat, proxy, control plane  │        │ │ 
  │ │       └────────────────────────────┘        │ │ 
  │ └─────────────────────────────────────────────┘ │ 
  │ ┌─────────────────────────────────────────────┐ │ 
  │ │               Private Subnet                │ │ 
  │ │                                             │ │ 
  │ │       ┌──────────┐      ┌───────────┐       │ │ 
  │ │       │          │      │           │       │ │ 
  │ │       │ ec2-mon  │      │  ec2-ci   │       │ │ 
  │ │       │          │      │           │       │ │ 
  │ │       └──────────┘      └───────────┘       │ │ 
  │ │                                             │ │ 
  │ │      ┌───────────┐      ┌───────────┐       │ │ 
  │ │      │           │      │           │       │ │ 
  │ │      │  ec2-f1   │      │  ec2-n1   │       │ │ 
  │ │      │           │      │           │       │ │ 
  │ │      └───────────┘      └───────────┘       │ │ 
  │ └─────────────────────────────────────────────┘ │ 
  └─────────────────────────────────────────────────┘ 
```

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
cp backend.hcl.example backend.hcl
terraform init -backend-config=backend.hcl
terraform validate
terraform plan
terraform apply
```
