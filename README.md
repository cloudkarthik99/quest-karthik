# Quest

## Deploy containerized Node.js Application in Cloud

This repo contains the infrastructure source code to deploy containerised application in AWS and GCP.

## Prerequisites:
  - AWS account
  - GCP account
  - Domain name (optional, we can use ELB DNS)

## Installations:
  - Git
  - Docker CLI for creating and pushing images
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

please refer to the README.md files of cloud specific folders for more info.

## Improvements

The current setup can be deployed in multiple ways apart from either ECS or GKE. 
Basic research gave me several serverless deployment ideas to acheive this.

### CI/CD:
This setup can become much robust and clean with CI/CD implementation using Gitlab CI, Github Actions. 
This can be implemented if spent little more time.
I even have the source code from my previous projects: https://gitlab.com/devops-learnin

> [!NOTE]
> Heavy usage of Claude.ai, chatgpt, Perplexity is used for research purposes for this quest