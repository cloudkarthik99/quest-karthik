
# Deploy Node.js application on GKE cluster

### Architecture:


Why GKE cluster and why not Cloud Run:
  1. Familiarity with the experience in K8s framework.
  2. Cloud Run also perfectly works with standalone application like this quest, but its still immature and I already explored 
     the familiar service from AWS for this quest i.e., AWS ECS.

creates:
  - VPC
    - subnet
    - router
    - NAT
  - GKE
    - Cluster
    - Custom Node pool
    - GKE Service Account
  - Backend
    - Folder to store Terraform state files in Cloud storage bucket(Already exists)
    
  - Manifests:
    - deploy.yaml - Deploy the Application using the docker image of node.js Application we created
    - service.yaml - To expose the application deployed internally with `clusterIP` 
    - cert.yaml - create certificate for LoadBalancer to use for HTTPS Traffic
    - ingress.yaml - Configure route for traffic to the backend Service, which in turn creates the  External Google Load Balancer

## 

#Image creation#


#Authenticate with the GCP account#

For terraform to authenticate and create resources in the specific project of GCP:

`gcloud auth application-default login`

Then configure the project where you want your resources to be deployed in:

`gcloud config set project PROJECT_ID`  

