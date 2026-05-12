variable "resource_prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "WizTestv1"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "eks_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.35"
}

variable "mongodb_instance_type" {
  description = "Instance type for MongoDB EC2"
  type        = string
  default     = "t3.micro"
}

variable "mongodb_username" {
  description = "MongoDB admin username"
  type        = string
  default     = "taskyadmin"
}

variable "mongodb_password" {
  description = "MongoDB admin password"
  type        = string
  sensitive   = true
  default     = "TaskyPassword123!"
}

variable "region2" {
  description = "AWS region2"
  type        = string
  default     = "us-west-1"
}
