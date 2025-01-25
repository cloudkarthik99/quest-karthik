# Deploy Node.js application on AWS ECS

## Infrastructure Overview
![quest-aws](https://github.com/user-attachments/assets/1aadbe59-6926-42bc-8f16-c6d017387f4a)


### Components Deployed
  - VPC: Private VPC with public and private subnets.
  - ECS Cluster: Fargate-based ECS cluster with tasks running in private subnets.
  - Application Load Balancer (ALB): Public ALB for HTTPS traffic termination and forwarding traffic to ECS tasks.
  - Node.js Application: Dockerized Node.js application deployed as ECS tasks.
  - Route 53 DNS: Configured to point a custom domain to the ALB.

### Security Measures
  - The ECS tasks run in private subnets with no direct internet access.
  - The ALB handles HTTPS traffic, ensuring secure communication.
  - IAM roles and policies are configured for least privilege.

## Installation & Setup

### 1. Authenticate with AWS SSO

Run the following command to configure AWS SSO:
```sh
$ aws configure sso
SSO session name (Recommended): my-sso
SSO start URL [None]: https://my-sso-portal.awsapps.com/start
SSO region [None]: us-east-1
SSO registration scopes [None]: sso:account:access
```
Save the configuration with a profile name (e.g., sso-profile).

### Log in to AWS SSO:
```sh
aws sso login --profile sso-profile
```
Follow the steps below to deploy the GCP resources using Terraform:

### 2. Clone the Repository:

```sh
git clone git@github.com:cloudkarthik99/quest-karthik.git
cd aws-terraform
```
### 3. Initialize Terraform:
Navigate to the `aws-terraform` directory:

Initialize the Terraform configuration.

```sh
terraform init
```
### 4. Plan and Apply:
Review the changes Terraform will make and apply them.

```sh
terraform plan
terraform apply
```
## Testing the Setup
### Access the Application

Open your browser and navigate to your custom domain (e.g., quest.thetechvoyager.in).
## Cleaning Up
To destroy the infrastructure created by Terraform, run the following command:

```sh
terraform destroy
```
