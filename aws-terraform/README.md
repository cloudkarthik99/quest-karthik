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
## Troubleshooting: 
1. 5** Errors:
   Confirm if the Backend target of Load Balancer is healthy and the port configuration is matching to reach the backend endpoint
   ![image](https://github.com/user-attachments/assets/7d8e8190-910d-48a5-b692-3f24e97f1ce4)
2. If the `HTTPS` endpoint is failing with `SSL: CERTIFICATE_VERIFY_FAILED` error:
   Its most probably the certificate is still being verified and provisioned by certificate Authority to check the authenticity of the certificate. Please try again after some time.

# Images:
1. Load Balancer:
   ![image](https://github.com/user-attachments/assets/bb915e0e-7b58-40d6-8bcb-9e9b70156682)
2. Load Balancer Backend Target Group:
 ![image](https://github.com/user-attachments/assets/c843760d-029a-4470-953e-99debdc5da72)
3. Certificate:
  ![image](https://github.com/user-attachments/assets/5fb86b2e-3878-4794-947b-94ff705b4804)
  ![image](https://github.com/user-attachments/assets/7df90d1f-bd07-4fa2-aa14-51a279f0760a)
5. VPC and Subnets:
   ![image](https://github.com/user-attachments/assets/6b07be12-c4dc-4152-8676-2e37b0255e69)
   ![image](https://github.com/user-attachments/assets/e434dd0d-6c97-44f1-a144-ba8371d0d2b8)
6. IAM for ECS:
   ![image](https://github.com/user-attachments/assets/cb35331b-a2e3-4433-ba47-11af40c02e46)
7. ECS Cluster:
   ![image](https://github.com/user-attachments/assets/33ce4519-c791-47e1-a582-3834ed1a02b1)
8. ECS service & Task-definition:
   ![image](https://github.com/user-attachments/assets/cb4df9da-6bc5-4653-8b96-469442c1b672)
   ![image](https://github.com/user-attachments/assets/be2b2e7f-53ed-4e40-aaae-a08c40193688)
9. ECS Autoscaling Group:
   ![image](https://github.com/user-attachments/assets/dfcaaf31-2c77-4c40-b2db-c65fc4090358)
10. EC2 Instance:
    ![image](https://github.com/user-attachments/assets/eb217fd7-3e5b-4b22-ae34-2a238e50fd14)
11. Route53:
    ![image](https://github.com/user-attachments/assets/62e89ed9-f5a4-44ed-8117-fa9867490f4b)

## The Output:
![image](https://github.com/user-attachments/assets/fb217eb9-6a51-4261-a5eb-b962b7d0d2fd)

