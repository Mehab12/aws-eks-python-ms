data "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = helm_release.jenkins.namespace
  }
}

data "kubernetes_service" "grafana" {
  metadata {
    name      = "monitoring-grafana"
    namespace = helm_release.monitoring.namespace
  }
}

data "kubernetes_service" "prometheus" {
  metadata {
    name      = "monitoring-kube-prometheus-stack-prometheus"
    namespace = helm_release.monitoring.namespace
  }
}
