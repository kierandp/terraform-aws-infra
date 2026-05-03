# ------------------------------------------------------------------------------
# VPC ARCHITECTURE
# ------------------------------------------------------------------------------

vpc_configs = {
  dev = {
    vpc_cidr = "10.0.0.0/16"

    public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.4.0/24"]
    private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

    availability_zones = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]

    tags = {
      Name        = "dev-vpc"
      Environment = "dev"
    }
  }
}
# ------------------------------------------------------------------------------
# S3 ARCHITECTURE
# ------------------------------------------------------------------------------

s3_configs = {
  public_bucket = {
    bucket_name         = "my-s3-bucket-first-project"
    versioning_enabled  = true
    public_access_block = false
    force_destroy       = true
    enable_encryption   = true

    bucket_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-s3-bucket-first-project/*"
    }
  ]
}
EOF
    tags = {
      Name = "dev"
    }
  }

  private_bucket = {
    bucket_name         = "my-s3-bucket-firstproject-backend-state-v2"
    versioning_enabled  = true
    public_access_block = true
    force_destroy       = true
    enable_encryption   = true

    tags = {
      Name = "dev"
    }
  }
}

# ------------------------------------------------------------------------------
# IAM ARCHITECTURE  
# ------------------------------------------------------------------------------

iam_configs = {
  dev = {
    user_count = 5

    assume_role_policy = {
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::589609245686:root"
        }
        Action = "sts:AssumeRole"
      }]
    }

    policy = {
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Action = [
          "s3:List*",
          "s3:Get*",
          "s3:Put*",
          "s3:Delete*",
          "ec2:*"
        ]
        Resource = "*"
      }]
    }

    tags = {
      Env = "dev"
    }
  }
}

# ------------------------------------------------------------------------------
# RDS ARCHITECTURE
# ------------------------------------------------------------------------------

rds_configs = {
  dev = {
    engine            = "postgres"
    engine_version    = "15"
    instance_class    = "db.t3.micro"
    allocated_storage = 20
    db_name           = "appdb"
    username          = "first_project_db_name"
    password          = "first_project_db_password"

    tags = {
      env = "dev"
    }
  }
}

# ------------------------------------------------------------------------------
# SG ARCHITECTURE
# ------------------------------------------------------------------------------

sg_configs = {
  dev = {
    vpc_key = "dev"

    alb = {
      name          = "dev-alb-sg"
      ingress_ports = [80, 443]
    }

    app = {
      name          = "dev-app-sg"
      ingress_ports = [80]
    }

    rds = {
      name          = "dev-rds-sg"
      ingress_ports = [5432]
    }
  }
}

# ------------------------------------------------------------------------------
# EC2 ARCHITECTURE
# ------------------------------------------------------------------------------

ec2_configs = {
  dev = {
    name          = "dev-server"
    instance_type = "t3.micro"
    iam_role_key  = "dev"
    sg_keys       = ["app"]
    tags = {
      env = "dev"
    }

  }
}

# ------------------------------------------------------------------------------
# ALB ARCHITECTURE
# ------------------------------------------------------------------------------

alb_configs = {
  dev = {
    name           = "app-alb"
    subnet_keys    = ["dev-public-0", "dev-public-1"]
    security_group = "alb"
    target_port    = 80
    listener_port  = 80
    tags = {
      env = "dev"
    }

  }
}