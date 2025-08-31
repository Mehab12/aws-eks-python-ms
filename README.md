# aws-eks-python-ms
Python microservice on Kubernetes on AWS
Python Microservice Deployment on AWS EKS with Jenkins CI/CD
Table of Contents
Overview
Repository Structure
Prerequisites
Infrastructure Provisioning
Dockerizing the Application
Jenkins Pipeline
Deploying to Kubernetes
Exposing the Service
Monitoring
Future Enhancements
References
Overview
This project demonstrates the deployment of a Python microservice on AWS EKS using Terraform for infrastructure provisioning, Docker for containerization, and Jenkins for CI/CD automation. It also includes a monitoring stack to track Kubernetes and application metrics.
Repository Structure
├── Dockerfile                 # Dockerfile to containerize Python app
├── k8s/
│   ├── deployment.yaml        # Kubernetes Deployment manifest
│   └── service.yaml           # Kubernetes Service manifest
├── terraform/
│   ├── main.tf
│   ├── vpc.tf
│   ├── eks.tf
│   ├── ecr.tf
│   ├── secrets.tf
│   ├── jenkins.tf
│   ├── monitoring.tf
│   ├── variables.tf
│   └── outputs.tf
├── Jenkinsfile                # CI/CD pipeline definition
└── README.md                  # Project documentation
Prerequisites
AWS account with permissions to create EKS, EC2, ECR, IAM roles, and Secrets Manager.
Terraform installed (v1.6+ recommended).
AWS CLI installed and configured.
kubectl installed.
Docker installed.
Jenkins server access for pipeline execution.
Infrastructure Provisioning
Initialize Terraform:
cd terraform
terraform init
Plan the deployment:
terraform plan
Apply Terraform to provision infrastructure:
terraform apply
Components deployed:
VPC, subnets, NAT gateways
EKS Cluster & Node Groups
ECR Repository
Jenkins (Helm on EKS)
Grafana monitoring stack
AWS Secrets Manager for Jenkins/Grafana credentials
Dockerizing the Application
Dockerfile Example:
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

CMD ["python", "app.py"]
Build and Test Locally:
docker build -t microservice-dev .
docker run -p 5000:5000 microservice-dev
Jenkins Pipeline
The Jenkins pipeline handles:
Checking out the source code from GitHub.
Building Docker images.
Logging into ECR and pushing images.
Updating kubeconfig for EKS cluster.
Deploying the microservice to Kubernetes.
Verifying deployment with kubectl.
Pipeline parameters:
AWS region, EKS cluster name
ECR repository name and image tag
Git repository URL and branch
Manual deployment via Jenkins UI is currently set up. Future enhancements include full Terraform automation of pipelines.
Deploying to Kubernetes
Deployment manifest (k8s/deployment.yaml) example:
apiVersion: apps/v1
kind: Deployment
metadata:
  name: python-microservice
spec:
  replicas: 1
  selector:
    matchLabels:
      app: python-microservice
  template:
    metadata:
      labels:
        app: python-microservice
    spec:
      containers:
      - name: python-microservice
        image: ${IMAGE}
        ports:
        - containerPort: 5000
Service manifest (k8s/service.yaml) example:
apiVersion: v1
kind: Service
metadata:
  name: python-microservice-service
spec:
  type: LoadBalancer
  selector:
    app: python-microservice
  ports:
  - protocol: TCP
    port: 80
    targetPort: 5000
Deploy manually (optional):
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl rollout status deployment/python-microservice
Exposing the Service
The service uses LoadBalancer type. Check the external IP:
kubectl get svc python-microservice-service
Access the microservice via the assigned public endpoint.
Monitoring
Grafana is deployed on Kubernetes via Terraform.
Prometheus is configured for metrics collection.
Monitor cluster health, pod CPU/memory, and application metrics.
Future Enhancements
Fully automate Jenkins pipelines using Terraform.
Add a pipeline for automatic ECR image updates from GitHub commits.
Add a pipeline for Kubernetes deployment triggered by Docker image changes.
Integrate alerting via Grafana/Prometheus for production readiness.
References
AWS EKS Documentation
Terraform AWS Provider
Jenkins Pipeline Syntax
Kubernetes Documentation
