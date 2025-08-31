# ---------------------- Random Passwords ----------------------
resource "random_password" "jenkins" {
  length           = 16
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  keepers = {
    cluster = var.cluster_name
  }
}

resource "random_password" "grafana" {
  length           = 16
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
  keepers = {
    cluster = var.cluster_name
  }
}

# ---------------------- KMS Key ----------------------
resource "aws_kms_key" "secrets" {
  description             = "KMS key for Secrets Manager encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "secrets" {
  name          = "alias/${var.cluster_name}-secrets"
  target_key_id = aws_kms_key.secrets.key_id
}

# ---------------------- AWS Secrets Manager ----------------------
resource "aws_secretsmanager_secret" "jenkins" {
  name                    = "${var.jenkins_name}-jenkins-v3"
  kms_key_id              = aws_kms_key.secrets.arn
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "jenkins" {
  secret_id     = aws_secretsmanager_secret.jenkins.id
  secret_string = jsonencode({
    username = var.jenkins_admin_user
    password = random_password.jenkins.result
  })
}

resource "aws_secretsmanager_secret" "grafana" {
  name                    = "${var.grafana_name}-grafana-v3"
  kms_key_id              = aws_kms_key.secrets.arn
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "grafana" {
  secret_id     = aws_secretsmanager_secret.grafana.id
  secret_string = jsonencode({
    username = var.grafana_admin_user
    password = random_password.grafana.result
  })
}


