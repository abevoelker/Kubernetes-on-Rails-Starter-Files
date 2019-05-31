variable "cloudflare_email" {
  type = "string"
}

variable "cloudflare_token" {
  type = "string"
}

variable "domain" {}

data "google_project" "project" {}


provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}


resource "cloudflare_record" "website-a" {
  domain = "${var.domain}"
  name   = "${data.google_project.project.project_id}"
  value  = "${google_compute_global_address.ipv4.address}"
  type   = "A"
  ttl    = 300
}

resource "cloudflare_record" "website-aaaa" {
  domain = "${var.domain}"
  name   = "${data.google_project.project.project_id}"
  value  = "${google_compute_global_address.ipv6.address}"
  type   = "AAAA"
  ttl    = 300
}

resource "cloudflare_record" "assets-a" {
  domain = "${var.domain}"
  name   = "${data.google_project.project.project_id}-assets"
  value  = "${google_compute_global_address.ipv4.address}"
  type   = "A"
  ttl    = 300
}

resource "cloudflare_record" "assets-aaaa" {
  domain = "${var.domain}"
  name   = "${data.google_project.project.project_id}-assets"
  value  = "${google_compute_global_address.ipv6.address}"
  type   = "AAAA"
  ttl    = 300
}
