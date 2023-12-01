resource "google_project_service" "cloudbuild_api" {
  project                    = var.project_id
  service                    = "cloudbuild.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
  lifecycle {
    ignore_changes = [project]
  }
}

resource "google_project_service" "app_engine" {
  project = var.project_id
  service = "appengine.googleapis.com"

  disable_dependent_services = true
}

resource "google_app_engine_application_url_dispatch_rules" "appengine-app-dispatch-rules" {
  dispatch_rules {
    domain = "*"
    path = "/*"
    service = "default"
  }
}

resource "google_app_engine_application" "default" {
  project     = var.project_id
  location_id = var.region
}

resource "google_storage_bucket" "app" {
  name          = "${var.project_id}-${random_id.app.hex}-app"
  location      = var.region
  force_destroy = true
  versioning {
    enabled = true
  }
}

resource "random_id" "app" {
  byte_length = 8
}