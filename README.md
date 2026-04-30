# AWS Infrastructure Automation with Terraform

## Overview

This project provisions a modular AWS infrastructure using Terraform, following Infrastructure as Code (IaC) best practices.

It deploys a highly available, scalable multi-tier architecture with automated CI/CD, designed to simulate a real-world cloud environment.


##  Architecture

Internet
              ↓
   Application Load Balancer (ALB)
              ↓
     Auto Scaling Group (EC2)
              ↓
     RDS Database (Private Subnets)
              ↓
         S3 Object Storage

### Key Design Principles

* High Availability → Multi-AZ deployment
* Scalability → Auto Scaling Groups with dynamic policies
* Security → Private subnets, IAM roles, security groups
* Modularity → Reusable Terraform modules
* Automation → CI/CD pipeline for infrastructure deployment


##  Project Structure

Terraform AWS Infra/
│
├── dev/
│   ├── main.tf
│   ├── variable.tf
│   └── terraform.tfvars
│
└── modules/
    ├── vpc/   # Networking (subnets, routing, gateways)
    ├── sg/    # Security groups
    ├── ec2/   # Launch templates + Auto Scaling
    ├── alb/   # Load balancer + target groups
    ├── rds/   # Relational database
    ├── s3/    # Object storage
    └── iam/   # Roles and instance profiles


##  Infrastructure Components

###  Networking (VPC)

* Custom VPC with public and private subnets
* Subnets distributed across multiple Availability Zones
* Internet Gateway and route tables configured
* Private isolation for compute and database layers


### Compute (EC2 + Auto Scaling)

* Launch Templates for standardized instance configuration
* Auto Scaling Groups:

  * Min: 3
  * Desired: 3
  * Max: 6
* Integrated with ALB target groups
* CPU-based scaling via CloudWatch alarms


### Load Balancing (ALB)

* Application Load Balancer for traffic distribution
* Health checks for instance monitoring
* Target groups linked to Auto Scaling Groups


### Data Layer

* RDS deployed in private subnets (not publicly accessible)
* S3 bucket with encryption enabled


### 🔹 Security

* Modular security group configuration
* IAM roles and instance profiles (no hardcoded credentials)
* Principle of least privilege applied


##  Remote State Management

```hcl
terraform {
  backend "s3" {
    bucket       = "my-s3-bucket-firstproject-backend-state-v3"
    key          = "path/to/my/key"
    region       = "ap-southeast-1"
    use_lockfile = false
  }
}
```

### Features

* Remote state stored in S3
* Centralized state management for consistent deployments

##  CI/CD Pipeline

Automated using GitHub Actions:

### On Pull Request:

* `terraform fmt -check`
* `terraform validate`
* `terraform plan`

### On Push to `main`:

* `terraform apply -auto-approve`

### Features:

* AWS credentials managed via GitHub Secrets
* Terraform CLI setup via official actions
* Environment-based deployment (`dev/`)


##  Deployment

Run locally:

```bash
cd dev/
terraform init
terraform plan
terraform apply
```


##  Technologies Used

* Terraform
* AWS EC2 (Auto Scaling, Launch Templates)
* AWS VPC (Subnets, Routing)
* AWS ALB (Load Balancing)
* AWS RDS (Database)
* AWS S3 (Storage)
* AWS IAM (Security)
* GitHub Actions (CI/CD)
