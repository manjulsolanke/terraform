# Define provider and AWS region
provider "aws" {
  region = "us-west-2"  # Replace with your desired region
}

# Use Terraform EKS module
module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "x.x.x"  # Replace with the desired version of the module

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.21"  # Replace with your desired EKS cluster version
  subnets         = ["subnet-12345678", "subnet-87654321"]  # Replace with your existing subnet IDs
  vpc_id          = "vpc-12345678"  # Replace with your existing VPC ID

  worker_groups = [
    {
      instance_type = "t3.medium"  # Replace with your desired instance type
      asg_min_size  = 1
      asg_max_size  = 3
    }
  ]
}

# Configure kubectl to authenticate with the EKS cluster
data "aws_eks_cluster_auth" "cluster_auth" {
  name = module.eks_cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster_auth.cluster_auth.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster_auth.cluster_auth.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  load_config_file       = false
  version                = "~> 1.13"  # Replace with your desired version
}

# Example resource to deploy a Kubernetes deployment
resource "kubernetes_deployment" "example_deployment" {
  metadata {
    name = "example-deployment"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "example-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "example-app"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "example-container"
        }
      }
    }
  }
}

