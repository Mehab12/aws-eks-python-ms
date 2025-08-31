# Microservice Kubernetes Deployment

## Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform installed
- Docker installed
- kubectl installed

## Deployment Steps

### 1. Provision EKS Cluster
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 2. Configure kubectl
```bash
aws eks update-kubeconfig --region us-west-2 --name microservice-cluster
```

### 3. Build and Deploy
```bash
# Build Docker image
docker build -t python-microservice:latest .

# Deploy to Kubernetes
kubectl apply -f k8s/deployment.yaml
```

### 4. Verify Deployment
```bash
kubectl get pods
kubectl get services
```

## Quick Deploy
Run the automated script:
```bash
chmod +x deploy.sh
./deploy.sh
```

## Cleanup
```bash
kubectl delete -f k8s/deployment.yaml
cd terraform
terraform destroy
```