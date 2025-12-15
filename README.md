# Task 6: Strapi CI/CD Pipeline

This project implements a **complete CI/CD pipeline** for deploying Strapi on AWS EC2 using **GitHub Actions**, **Docker**, **ECR**, and **Terraform**.

## Features

- **CI Workflow** (`.github/workflows/ci.yml`)
  - Builds Strapi Docker image
  - Pushes image to AWS ECR
  - Tags latest version

- **CD Workflow** (`.github/workflows/cd.yml`)
  - Provisions EC2 instance using Terraform
  - Pulls Docker image from ECR
  - Starts Strapi container
  - Verifies deployment with health check

- **Terraform Files**
  - EC2 instance, Security Group, IAM key
  - User-data script for Docker and Strapi
  - Outputs EC2 public IP

- **Verification**
  - Health check endpoint: `http://<EC2_PUBLIC_IP>:1337/_health`
  - Admin panel: `http://<EC2_PUBLIC_IP>:1337/admin`
  - SSH access: `ssh -i Terraform/khaleel-aws-key.pem ubuntu@<EC2_PUBLIC_IP>`

## Usage

1. Push code to `main` → CI workflow builds and pushes Docker image.
2. Run CD workflow manually → Deploys Strapi to EC2.
3. Check deployment via health endpoint or Admin panel.

---

**Status:** ✅ Completed
