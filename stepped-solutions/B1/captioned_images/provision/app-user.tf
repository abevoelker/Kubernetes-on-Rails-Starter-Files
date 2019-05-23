resource "google_service_account" "app-user" {
  account_id = "app-user"
}

resource "google_service_account_key" "app-user-key" {
  service_account_id = "${google_service_account.app-user.name}"
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_storage_bucket_iam_binding" "app-bucket-images" {
  bucket = "${google_storage_bucket.image-store.name}"
  role   = "roles/storage.admin"

  members = [
    "serviceAccount:${google_service_account.app-user.email}",
  ]
}

resource "google_project_iam_binding" "storage" {
  role = "roles/storage.admin"

  members = [
    "serviceAccount:${google_service_account.app-user.email}",
  ]
}

output "app_user_key" {
  value     = "${google_service_account_key.app-user-key.private_key}"
  sensitive = true
}
