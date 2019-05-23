variable "project_id" {}

output "project_id" {
  value = "${var.project_id}"
}

provider "google" {
  credentials = "${file("keyfiles/keyfile.json")}"
  project     = "${var.project_id}"
  region      = "us-central1"
}

provider "google-beta" {
  credentials = "${file("keyfiles/keyfile.json")}"
  project     = "${var.project_id}"
  region      = "us-central1"
}

// Container registry
resource "google_project_service" "containerregistry" {
  service            = "containerregistry.googleapis.com"
  disable_on_destroy = false
}

data "google_container_registry_repository" "foo" {}

output "container_registry_url" {
  value = "${data.google_container_registry_repository.foo.repository_url}"
}

// Reserved IP addresses
resource "google_compute_global_address" "ipv4" {
  name       = "webapp-ipv4"
  ip_version = "IPV4"
}

resource "google_compute_global_address" "ipv6" {
  name       = "webapp-ipv6"
  ip_version = "IPV6"
}

// Cloudbuild API
resource "google_project_service" "cloudbuild" {
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}
