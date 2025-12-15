resource "aws_key_pair" "strapi_key" {
  key_name   = var.key_name
  public_key = file("${path.cwd}/${var.key_name}.pub")
}

resource "aws_instance" "strapi_ec2" {
  ami                         = "ami-02b8269d5e85954ef"  # Ubuntu 22.04 (ap-south-1)
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.strapi_key.key_name
  vpc_security_group_ids      = [aws_security_group.strapi_sg.id]
  associate_public_ip_address = true

  # IAM Instance Profile
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # User data
  user_data = templatefile("user-data.sh", {
    image_tag  = var.image_tag
    ecr_repo   = var.ecr_repo
    aws_region = var.aws_region
  })

  tags = {
    Name    = "Strapi-EC2"
    Project = "Strapi-Deployment"
  }
}
