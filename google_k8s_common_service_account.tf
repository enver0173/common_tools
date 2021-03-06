resource "kubernetes_service_account" "common_service_account" {
  metadata {
    name = "common-service-account"
    namespace = "${var.deployment_environment}"
  }
  secret {
    name = "${kubernetes_secret.common_service_account_secret.metadata.0.name}"
  }
  automount_service_account_token = true
}

resource "kubernetes_secret" "common_service_account_secret" {
  metadata {
    name = "common-service-account-secret"
    namespace = "${var.deployment_environment}"
  }
}

resource "kubernetes_cluster_role_binding" "common_cluster_rule" {
    depends_on = [
      "kubernetes_secret.common_service_account_secret"
    ]
    metadata {
        name = "common-cluster-rule"
    }
    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind      = "ClusterRole"
        name      = "cluster-admin"
    }
    subject {
        kind      = "ServiceAccount"
        name      = "${kubernetes_service_account.common_service_account.metadata.0.name}"
        namespace = "${kubernetes_service_account.common_service_account.metadata.0.namespace}"
    }
}
