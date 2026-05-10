resource "aws_key_pair" "mongodb_key" {
  key_name   = "${var.resource_prefix}MongoKey"
  public_key = file("${path.module}/WizTestv1MongoKey.pub")
  tags = {
    Name        = "${var.resource_prefix}MongoKey"
    Environment = var.resource_prefix
    Project     = "WizExercise"
  }
}

resource "aws_security_group" "mongodb_sg" {
  name        = "${var.resource_prefix}MongoSecurityGroup"
  description = "MongoDB EC2 security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH open to internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "MongoDB from EKS nodes"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.resource_prefix}MongoSecurityGroup"
    Environment = var.resource_prefix
    Project     = "WizExercise"
  }
}
# Ubuntu 20.04 official Canonical AMI, used as outdated Linux base for exercise
resource "aws_instance" "mongodb" {
  ami                         = "ami-0fb0b230890ccd1e6"
  instance_type               = var.mongodb_instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.mongodb_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.mongodb_key.key_name
  iam_instance_profile        = aws_iam_instance_profile.mongodb_instance_profile.name

  user_data = templatefile("${path.module}/scripts/mongodb-userdata.sh", {
    mongodb_username      = var.mongodb_username
    mongodb_password      = var.mongodb_password
    mongodb_backup_bucket = aws_s3_bucket.mongodb_backups.bucket
  })

  lifecycle {
    ignore_changes = [user_data]
  }

  tags = {
    Name        = "${var.resource_prefix}MongoEC2"
    Environment = var.resource_prefix
    Project     = "WizExercise"
  }
}