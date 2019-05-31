resource "random_id" "image-store" {
  byte_length = 4
}

resource "google_storage_bucket" "image-store" {
  name          = "image-store-${random_id.image-store.hex}"
  storage_class = "MULTI_REGIONAL"
}

resource "google_project_service" "storage-component" {
  service            = "storage-component.googleapis.com"
  disable_on_destroy = false
}

output "bucket_name" {
  value = "${google_storage_bucket.image-store.name}"
}
