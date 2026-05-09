# Wiz Technical Exercise

## Stack

- AWS
- Terraform
- EKS
- Helm
- Jenkins
- GitHub Actions
- Docker Hub
- MongoDB

## Architecture

- EKS worker nodes in private subnets
- Public load balancer
- MongoDB EC2
- Public S3 backup bucket

Disclaimer:

The environment is designed for security analysis and includes intentional misconfigurations such as public SSH access, public database backups, over-permissive IAM permissions, and cluster-admin Kubernetes RBAC. (Do not fork it)


By Shridhar Kamma