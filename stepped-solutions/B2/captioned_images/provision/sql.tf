resource "random_id" "db-instance" {
  byte_length = 4
}

resource "google_sql_database_instance" "master" {
  name             = "master-instance-${random_id.db-instance.hex}"
  database_version = "POSTGRES_9_6"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = "false"
      private_network = "${google_compute_network.vpc_default.self_link}"
    }
  }

  depends_on = [
    "google_project_service.sqladmin",
  ]

  timeouts {
    create = "20m"
    update = "30m"
  }
}

resource "random_string" "db_password" {
  length  = 32
  special = false
}

resource "google_sql_user" "master-user" {
  name     = "user"
  instance = "${google_sql_database_instance.master.name}"
  password = "${random_string.db_password.result}"
}

resource "google_sql_database" "captioned-images" {
  name     = "captioned-images-db"
  instance = "${google_sql_database_instance.master.name}"
}

resource "google_compute_network" "vpc_default" {
  provider = "google-beta"
  name     = "default"

  lifecycle {
    ignore_changes  = ["description"]
    prevent_destroy = true
  }
}

resource "google_compute_global_address" "private_ip_address" {
  provider = "google-beta"

  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "${google_compute_network.vpc_default.self_link}"
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = "google-beta"

  network                 = "${google_compute_network.vpc_default.self_link}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["${google_compute_global_address.private_ip_address.name}"]

  depends_on = [
    "google_project_service.servicenetworking",
  ]
}

resource "google_project_service" "servicenetworking" {
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "sqladmin" {
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

locals {
  database_uri = "postgresql://${google_sql_user.master-user.name}:${google_sql_user.master-user.password}@${google_sql_database_instance.master.private_ip_address}/${google_sql_database.captioned-images.name}"
}

output "database_uri" {
  value     = "${local.database_uri}"
  sensitive = true
}
