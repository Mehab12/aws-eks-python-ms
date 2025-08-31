output "jenkins_url" {
  value = try(
    data.kubernetes_service.jenkins.status[0].load_balancer[0].ingress[0].hostname,
    "pending"
  )
}

output "grafana_url" {
  value = try(
    data.kubernetes_service.grafana.status[0].load_balancer[0].ingress[0].hostname,
    "pending"
  )
}

output "prometheus_url" {
  value = try(
    data.kubernetes_service.prometheus.status[0].load_balancer[0].ingress[0].hostname,
    "pending"
  )
}


output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "jenkins_secret_arn" {
  value = aws_secretsmanager_secret.jenkins.arn
}

output "grafana_secret_arn" {
  value = aws_secretsmanager_secret.grafana.arn
}
