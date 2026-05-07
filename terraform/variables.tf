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