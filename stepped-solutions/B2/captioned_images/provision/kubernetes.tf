provider "kubernetes" {
  host = "${google_container_cluster.primary.endpoint}"

  client_certificate     = "${base64decode(google_container_cluster.primary.master_auth.0.client_certificate)}"
  client_key             = "${base64decode(google_container_cluster.primary.master_auth.0.client_key)}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)}"
}

variable "SECRET_KEY_BASE" {}

resource "kubernetes_secret" "app-secrets" {
  "metadata" {
    name = "app-secrets"
  }

  data {
    DATABASE_URL = "${local.database_uri}"
    SECRET_KEY_BASE = "${var.SECRET_KEY_BASE}"
    GOOGLE_CLOUD_KEYFILE_JSON = "${base64decode(google_service_account_key.app-user-key.private_key)}"
  }
}
