# Quest

## Deploy containerized Node.js Application in Cloud

This repo contains the infrastructure source code to deploy containerised application in AWS and GCP.

## Prerequisites:
  - AWS account
  - GCP account
  - Domain name (optional, we can use ELB DNS)

## Installations:
  - Docker CLI
  - AWS CLI
  - Gcloud CLI
  - Terraform CLI
  - kubectl (needed for GCP only)

## Containerizing the Application
Follow these steps to containerize and deploy your Node.js application:

1. Create a Dockerfile in the root directory of your Node.js application.
2. Build the Docker image from the Dockerfile.
```sh
docker build -t your-image-name .
```
3. Push the Docker image to both AWS ECR and GCP GCR.

### AWS ECR:
```sh
aws ecr create-repository --repository-name your-repo-name
aws ecr get-login-password --region your-region | docker login --username AWS --password-stdin your-aws-account-id.dkr.ecr.your-region.amazonaws.com
docker tag your-image-name your-aws-account-id.dkr.ecr.your-region.amazonaws.com/your-repo-name
docker push your-aws-account-id.dkr.ecr.your-region.amazonaws.com/your-repo-name
```

### GCP GCR:
```sh
gcloud auth configure-docker
docker tag your-image-name gcr.io/your-project-id/your-repo-name
docker push gcr.io/your-project-id/your-repo-name
```

please refer to the README.md files of specific folders for more info.

