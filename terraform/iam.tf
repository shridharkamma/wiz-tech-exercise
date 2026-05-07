resource "aws_iam_role" "mongodb_ec2_role" {
  name = "${var.resource_prefix}MongoEC2Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.resource_prefix}MongoEC2Role"
    Environment = var.resource_prefix
    Project     = "WizExercise"
  }
}

resource "aws_iam_role_policy_attachment" "mongodb_admin_attach" {
  role       = aws_iam_role.mongodb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "mongodb_instance_profile" {
  name = "${var.resource_prefix}MongoInstanceProfile"
  role = aws_iam_role.mongodb_ec2_role.name

  tags = {
    Name        = "${var.resource_prefix}MongoInstanceProfile"
    Environment = var.resource_prefix
    Project     = "WizExercise"
  }
}