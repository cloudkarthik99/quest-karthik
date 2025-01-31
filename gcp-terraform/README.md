# Deploy Node.js application on GKE cluster
## Key Components:
  - VPC
    - subnet
    - router
    - NAT
  - GKE
    - Cluster
    - Custom Node pool
    - GKE Custom Service Account with necessary Permissions
  - Backend
    - Folder to store Terraform state files in Cloud storage bucket(Already exists)
  - Manifests:
    - deploy.yaml - Deploy the Application using the docker image of node.js Application we created
    - service.yaml - To expose the application deployed internally with `clusterIP` 
    - cert.yaml - create certificate for LoadBalancer to use for HTTPS Traffic
    - ingress.yaml - Configure route for traffic to the backend Service, which in turn creates the External Google Load Balancer
## GCP Terraform setup
> [!IMPORTANT]  
> Deploying Resources through terraform and Deploying K8s Manifests through kubectl is already done through CI/CD github actions
### 1. Authenticate with the GCP account
```
# For terraform to authenticate and create resources in the specific project of GCP:

gcloud auth application-default login

# Then configure the project where you want your resources to be deployed in:

gcloud config set project PROJECT_ID
```
Follow the steps below to deploy the GCP resources using Terraform:

### 2. Clone the Repository:

```sh
git clone git@github.com:cloudkarthik99/quest-karthik.git
cd gcp-terraform
```
### 3. Initialize Terraform:
Navigate to the `gcp-terraform` directory:

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
This will create the infrastructure required to deploy Node.js Application.
## Deploy Node.js Application

Once the GKE cluster creation is successfull
### 1. connect to the GKE cluster

```sh
gcloud container clusters get-credentials CLUSTER_NAME --zone us-east1-b --project PROJECT_ID
```
### 2. Apply Kubernetes Manifests
Navigate to the manifests directory and apply the Kubernetes manifests in the following order:

- Create the Namespace
```sh
kubectl apply -f namespace.yaml
```
- Deploy the Application
```sh
kubectl apply -f deploy.yaml
```
- Expose the Application
```sh
kubectl apply -f service.yaml
```
- Create the Certificate
```sh
kubectl apply -f cert.yaml
```
- Configure Ingress
```
# This ingress API resource automatically creates GCP External Load Balancer 
kubectl apply -f ingress.yaml
```
### 3. Verify Deployment
Ensure all resources are created and running correctly.

```sh
kubectl get deployments -n quest
kubectl get services -n quest
kubectl get certificates -n quest
kubectl get ingress -n quest
```
### 3. Access the Application

Once the Ingress is configured and the LoadBalancer is set up, you can access your Node.js application using the external IP address provided by the LoadBalancer.

## Associating Load Balancer IP with Domain Name in AWS Route 53
> [!WARNING]
> currently, The DNS management is in Route53, so the automatic attachment of LB's DNS to DNS record is not possible.
> Has to be done Manually
1. Obtain the Load Balancer's IP created by Ingress API resource and note the External IP address

2. In the Route 53 dashboard, click on “Hosted zones”. i.e., `thetechvoyager.in`
Select the public hosted zone that corresponds to your domain name which we mentioned in certificate creation.

In your hosted zone, click on the “Create record” button.
Configure the Record:

Record name: Enter the subdomain or leave it blank to use the root domain. In our case it is `gke-quest.thetechvoyager.in`.
Record type: Select A - IPv4 address if using an IP address,
Record target: Enter the Load Balancer’s IP address obtained from the GCP Console.

> [!IMPORTANT]  
> Make sure the Domain name is same as we used in certificate creation for TLS termination.
## Access the Application with Domain Name

Once the LoadBalancer IP to Route53 DNS set up is complete, you can access your Node.js application using the domain name `https://gke-quest.thetechvoyager.in`

## Troubleshooting: 
1. If faced with issue `ERR_CONNECTION_CLOSED`,  please make sure to add the LoadBalancer's IP to the  `gke-quest.thetechvoyager.in`
   ![image](https://github.com/user-attachments/assets/146161ed-82ac-49f4-8fe0-059c8f417c17)
2. 5** Errors:
   Confirm if the Backend target of Load Balancer is healthy and the port configuration is matching to reach the backend endpoint
   ![image](https://github.com/user-attachments/assets/7d8e8190-910d-48a5-b692-3f24e97f1ce4)
3. If the `HTTPS` endpoint is failing with `SSL: CERTIFICATE_VERIFY_FAILED` error:
   Its most probably the certificate is still being verified and provisioned by certificate Authority to check the authenticity of the certificate. Please try again after some time.


## Cleaning Up
To destroy the infrastructure created by Terraform, run the following command:

```sh
terraform destroy
```

Images:
1. Load Balancer:
   ![image](https://github.com/user-attachments/assets/5f94d557-af34-4d5e-9157-b9e9dd510b4d)
2. Load Balancer Backend (Default Kube-system backend created by GKE):
   ![image](https://github.com/user-attachments/assets/cdb4f191-5b9b-4558-af16-3b5da8013783)
3. Load Balancer Backend ( Backend Application Deployed and exposed via Ingress):
   ![image](https://github.com/user-attachments/assets/686901a6-0f64-4133-a419-da05f0f55fcb)
4. Certificate:
   ![image](https://github.com/user-attachments/assets/481ee793-5e82-4d3a-893c-dec110f23b46)
5. VPC and Subnets:
   ![image](https://github.com/user-attachments/assets/a63da218-921c-466c-a653-f38b289f4694)
6. Service Account for GKE:
   ![image](https://github.com/user-attachments/assets/a02a4870-2740-404b-9b05-3e23bee4cb34)
7. GKE Cluster:
   ![image](https://github.com/user-attachments/assets/f76bd4e1-31b8-4ecb-9939-ee5cc6c93b2d)
8. GKE custome Node Pool:
   ![image](https://github.com/user-attachments/assets/fe4f0fea-1be7-40cc-b200-f27929ab914a)
9. K8s cluster Deployments and services:
    ![image](https://github.com/user-attachments/assets/b714a646-4aa4-4dee-b650-2c8b46da9a0f)
10. Ingress:
    ![image](https://github.com/user-attachments/assets/1fba312c-5343-4d05-b38c-5d37e4a4961b)

## The Output:
![image](https://github.com/user-attachments/assets/002821d6-adcf-4a4b-a45c-59bb380c8e4f)
