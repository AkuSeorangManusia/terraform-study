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

## Modules

The root module owns provider, backend, environment inputs, shared tags, and
outputs. Infrastructure is separated into reusable local modules:

- `modules/network/vpc`, `internet_gateway`, and `subnets` — network foundations.
- `modules/network/public_route_table` and `private_route_table` — subnet routing.
- `modules/network/security_groups` — edge and private host access rules.
- `modules/key_pair` — EC2 SSH public-key registration.
- `modules/ec2` — NAT edge host and private hosts.

`environments/dev/moved.tf` preserves the previous module addresses during this
refactor. Keep it committed until the existing `dev` state has applied this
refactor.

## Usage

```bash
cd environments/dev
cp dev.tfvars.example dev.tfvars
cp backend.hcl.example backend.hcl
terraform init -backend-config=backend.hcl
terraform validate
terraform plan
terraform apply
```

`environments/dev` is the Terraform root module. Its `keys/`, `state/`, and
`.terraform/` directories are deliberately local-only and ignored by Git.
