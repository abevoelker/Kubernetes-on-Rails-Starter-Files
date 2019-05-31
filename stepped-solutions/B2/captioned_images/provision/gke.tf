resource "random_id" "gke-cluster" {
  byte_length = 4
}

resource "google_container_cluster" "primary" {
  name           = "my-gke-cluster-${random_id.gke-cluster.hex}"
  location       = "us-central1"
  node_locations = ["us-central1-a"]

  depends_on = [
    "google_project_service.container",
  ]

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true

  initial_node_count = 1

  min_master_version = "1.12.7-gke.17"

  ip_allocation_policy {
    use_ip_aliases = true
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "my-node-pool"
  location   = "${google_container_cluster.primary.location}"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = 3
  version    = "${google_container_cluster.primary.master_version}"

  node_config {
    machine_type = "n1-standard-1"

    metadata {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]
  }
}

resource "google_project_service" "container" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

output "gke_cluster_name" {
  value = "${google_container_cluster.primary.name}"
}
