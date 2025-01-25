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

1. Obtain the Load Balancer's IP created by Ingress API resource and note the External IP address

2. In the Route 53 dashboard, click on “Hosted zones”.
Select the public hosted zone that corresponds to your domain name which we mentioned in certificate creation.

In your hosted zone, click on the “Create record” button.
Configure the Record:

Record name: Enter the subdomain or leave it blank to use the root domain. In our case it is `gke-quest.thetechvoyager.in`.
Record type: Select A - IPv4 address if using an IP address,
Record target: Enter the Load Balancer’s IP address obtained from the GCP Console.

> [!IMPORTANT]  
> Make sure the Domain name is same as we used in certificate creation for TLS termination.
## Access the Application with Domain Name

Once the LoadBalancer IP to Route53 DNS set up is complete, you can access your Node.js application using the domain name `gke-quest.thetechvoyager.in`

## Cleaning Up
To destroy the infrastructure created by Terraform, run the following command:

```sh
terraform destroy
```