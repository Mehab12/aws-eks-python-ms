resource "helm_release" "jenkins" {
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version          = "5.1.9"
  namespace        = "jenkins"
  create_namespace = true
  timeout          = 600

  set {
    name  = "controller.serviceType"
    value = "LoadBalancer"  # was ClusterIP
  }

  set {
  name  = "controller.admin.username"
  value = var.jenkins_admin_user
}


  set {
    name  = "controller.admin.password"
    value = random_password.jenkins.result
  }

  depends_on = [module.eks]
}
