resource "helm_release" "monitoring" {
  name             = "monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "58.2.2"
  namespace        = "monitoring"
  create_namespace = true

  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "prometheus.service.type"
    value = "LoadBalancer" 
  }

  set {
    name  = "grafana.adminUser"
    value = var.grafana_admin_user
  }

  set {
    name  = "grafana.adminPassword"
    value = random_password.grafana.result
  }

  depends_on = [module.eks]
}
