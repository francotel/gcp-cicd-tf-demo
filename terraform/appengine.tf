resource "google_app_engine_application" "ts-appengine-app" {
  project     = var.project_id
  location_id = var.region
}

resource "google_app_engine_application_url_dispatch_rules" "appengine-app-dispatch-rules" {
  dispatch_rules {
    domain = "*"
    path = "/*"
    service = "default"
  }
}