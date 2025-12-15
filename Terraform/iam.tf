resource "aws_iam_role" "ec2_ecr_access" {
  name = "ec2-ecr-role-strapi-c"

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
}


resource "aws_iam_role_policy_attachment" "ec2_ecr_policy" {
  role       = aws_iam_role.ec2_ecr_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile-strapi-c"
  role = aws_iam_role.ec2_ecr_access.name
}