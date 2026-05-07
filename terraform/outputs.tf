output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_node_group_name" {
  value = keys(module.eks.eks_managed_node_groups)
}

output "eks_node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "mongodb_public_ip" {
  value = aws_instance.mongodb.public_ip
}

output "mongodb_private_ip" {
  value = aws_instance.mongodb.private_ip
}

output "mongodb_security_group_id" {
  value = aws_security_group.mongodb_sg.id
}

output "mongodb_connection_string" {
  value     = "mongodb://${var.mongodb_username}:${var.mongodb_password}@${aws_instance.mongodb.private_ip}:27017/tasky?authSource=admin"
  sensitive = true
}

output "mongodb_backup_bucket_name" {
  value = aws_s3_bucket.mongodb_backups.bucket
}

output "mongodb_backup_bucket_url" {
  value = "https://${aws_s3_bucket.mongodb_backups.bucket}.s3.amazonaws.com"
}