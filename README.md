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

# Extras/Improvements

The current setup can be deployed in multiple ways apart from ECS or GKE. 
Basic research gave me several serverless deployment ideas to acheive the same result as well.
Now Lets go on to the more advanced steps

## CI/CD:
This entire setup becomes more robust and clean with CI/CD implementation using Gitlab CI, Github Actions. 
we chose github actions for nativity with the github.

### Prerequisites
Setup Authentication with the both clouds to deploy Resources on AWS or GCP using Github Actions.
The best approach is:
**OIDC:** For the setup, Please refer to the `oidc-github-aws` and `oidc-github-gcp` covered in `manual-resources` project https://gitlab.com/devops-learnin

### Noticeable Features
1. The current workflows contains Manual approval action written to proceed with the further steps only if manually approved. cf:
   https://github.com/cloudkarthik99/quest-karthik/blob/main/.github/workflows/terraform_workflow_aws.yaml#L75
![image](https://github.com/user-attachments/assets/c8eabc7c-9cdb-4124-87a2-e6aba172eb71)
2. skip the step if no changes in Terraform:
   If there are no changes to be deployed or deleted via Terraform, we can skip the Terraform Apply or Destroy steps altogether saving the time.
   (This was explored with `exitcode` option, but couldnt get the expected results)

### Improvements Needed
1. Current Configuration contains only manual trigger of the required workflow pipeline with `Apply` or `Destroy` action. But this is not so hedious task to establish that `push` or `pull_request` trigger in the workflow.
   ![image](https://github.com/user-attachments/assets/c90f090d-70bb-4555-bd41-72325854a393)

3. Unclear view of the steps to confirm if the build was for Apply or Delete resources. cf:
   ![image](https://github.com/user-attachments/assets/f4483d10-6a28-4ca2-9c23-656c551fde89)
   I couldnt think of better approach at this moment to explore this issue. (eg: Maybe Variablizing the parameter)
   
Terraform AWS Workflow: ![image](https://github.com/user-attachments/assets/2bdf3c02-c954-4d71-b35f-d2f7400bfef8)
Terraform GCP Workflow: ![image](https://github.com/user-attachments/assets/64d5aedf-97c9-4e48-9bda-3a107864cfe9)


please refer to the README.md files of cloud specific folders for more info. 
 - AWS Readme: https://github.com/cloudkarthik99/quest-karthik/blob/main/aws-terraform/README.md
 - GCP Readme: https://github.com/cloudkarthik99/quest-karthik/blob/main/gcp-terraform/README.md
   
> [!NOTE]
> Heavy usage of Claude.ai, chatgpt, Perplexity is used for research purposes for this quest
