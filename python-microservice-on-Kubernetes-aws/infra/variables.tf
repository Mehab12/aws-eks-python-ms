variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "microservice-cluster"
}
variable "ecr_repo_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "microservice-dev"
}
variable "grafana_name" {
  description = "Name of the Grafana instance"
  type        = string
  default     = "grafana-dev"
}
variable "jenkins_name" {
  description = "Name of the Jenkins instance"
  type        = string
  default     = "jenkins-dev"
}
variable "jenkins_admin_user" {
  description = "Jenkins admin username"
  type        = string
  default     = "admin"
}

variable "grafana_admin_user" {
  description = "Grafana admin username"
  type        = string
  default     = "admin"
}
variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.48.0/20", "10.0.64.0/20"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.16.0/20"] 
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "eks_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.31"
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
  default     = "worker-node"
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_capacity" {
  description = "Desired number of nodes in the node group"
  type    = number
  default = 2
}

variable "node_min_capacity" {
  description = "Minimum number of nodes in the node group"
  type    = number
  default = 1
}

variable "node_max_capacity" {
  description = "Maximum number of nodes in the node group"
  type    = number
  default = 3
}

variable "single_nat_gateway" {
  description = "Use single NAT gateway for cost optimization"
  type        = bool
  default     = true

}
