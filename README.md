# Python Microservice Deployment on AWS EKS with Jenkins CI/CD

## Table of Contents

1. [Overview](#overview)
2. [Repository Structure](#repository-structure)
3. [Prerequisites](#prerequisites)
4. [Infrastructure Provisioning](#infrastructure-provisioning)
5. [Dockerizing the Application](#dockerizing-the-application)
6. [Jenkins Pipeline](#jenkins-pipeline)
7. [Deploying to Kubernetes](#deploying-to-kubernetes)
8. [Exposing the Service](#exposing-the-service)
9. [Monitoring](#monitoring)
10. [Future Enhancements](#future-enhancements)
11. [References](#references)

---

## Overview

This project demonstrates the deployment of a Python microservice on **AWS EKS** using **Terraform** for infrastructure provisioning, **Docker** for containerization, and **Jenkins** for CI/CD automation. It also includes a monitoring stack to track Kubernetes and application metrics.

---

## Repository Structure

```
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
```

---

## Prerequisites

* AWS account with permissions to create EKS, EC2, ECR, IAM roles, and Secrets Manager.
* **Terraform** installed (v1.6+ recommended).
* **AWS CLI** installed and configured.
* **kubectl** installed.
* **Docker** installed.
* **Jenkins** server access for pipeline execution.

---

## Infrastructure Provisioning

1. **Initialize Terraform**:

```bash
cd terraform
terraform init
```

2. **Plan the deployment**:

```bash
terraform plan
```

3. **Apply Terraform to provision infrastructure**:

```bash
terraform apply
```

**Components deployed:**

* VPC, subnets, NAT gateways
* EKS Cluster & Node Groups
* ECR Repository
* Jenkins (Helm on EKS)
* Grafana monitoring stack
* AWS Secrets Manager for Jenkins/Grafana credentials

---

## Dockerizing the Application

**Dockerfile Example:**

```dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

CMD ["python", "app.py"]
```

**Build and Test Locally:**

```bash
docker build -t microservice-dev .
docker run -p 5000:5000 microservice-dev
```

---

## Jenkins Pipeline

The **Jenkins pipeline** handles:

1. Checking out the source code from GitHub.
2. Building Docker images.
3. Logging into ECR and pushing images.
4. Updating `kubeconfig` for EKS cluster.
5. Deploying the microservice to Kubernetes.
6. Verifying deployment with `kubectl`.

**Pipeline parameters**:

* AWS region, EKS cluster name
* ECR repository name and image tag
* Git repository URL and branch

**Manual deployment** via Jenkins UI is currently set up. Future enhancements include full Terraform automation of pipelines.

---

## Deploying to Kubernetes

1. **Deployment manifest (`k8s/deployment.yaml`) example:**

```yaml
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
```

2. **Service manifest (`k8s/service.yaml`) example:**

```yaml
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
```

**Deploy manually (optional)**:

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl rollout status deployment/python-microservice
```

---

## Exposing the Service

The service uses `LoadBalancer` type. Check the external IP:

```bash
kubectl get svc python-microservice-service
```

Access the microservice via the assigned public endpoint.

---

## Monitoring

* **Grafana** is deployed on Kubernetes via Terraform.
* **Prometheus** is configured for metrics collection.
* Monitor cluster health, pod CPU/memory, and application metrics.

---

## Future Enhancements

1. Fully automate Jenkins pipelines using Terraform.
2. Add a pipeline for automatic ECR image updates from GitHub commits.
3. Add a pipeline for Kubernetes deployment triggered by Docker image changes.
4. Integrate alerting via Grafana/Prometheus for production readiness.

---

## References

* [AWS EKS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
* [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
* [Kubernetes Documentation](https://kubernetes.io/docs/home/)
