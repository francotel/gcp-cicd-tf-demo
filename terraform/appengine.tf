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
    domain  = "*"
    path    = "/*"
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
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

resource "random_id" "app" {
  byte_length = 8
}

data "archive_file" "app_dist" {
  type        = "zip"
  source_dir  = "../app"
  output_path = "../app/app.zip"
}

resource "google_storage_bucket_object" "app" {
  name           = "app.zip"
  source         = data.archive_file.app_dist.output_path
  bucket         = google_storage_bucket.app.name
}

resource "google_sql_database_instance" "main" {
  name             = "main-instance"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }

}

resource "google_sql_database" "default" {
  name       = "database"
  instance   = google_sql_database_instance.main.name
  charset    = "UTF8"
  collation  = "en_US.UTF8"
}

output "db" {
  value = google_sql_database_instance.main
  sensitive = true
}

resource "google_app_engine_standard_app_version" "latest_version" {

  version_id      = var.deployment_version
  service         = "default"
  runtime         = "nodejs20"
  app_engine_apis = false

  entrypoint {
    shell = "node app.js"
  }

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.app.name}/${google_storage_bucket_object.app.name}"
    }
  }

  instance_class = "F1"

  automatic_scaling {
    max_concurrent_requests = 10
    min_idle_instances      = 1
    max_idle_instances      = 2
    min_pending_latency     = "1s"
    max_pending_latency     = "5s"
    standard_scheduler_settings {
      target_cpu_utilization        = 0.5
      target_throughput_utilization = 0.75
      min_instances                 = 0
      max_instances                 = 2
    }
  }

  # env_variables = {
  #   DB_ADDR = "${google_sql_database_instance.main.host}:${google_sql_database_instance.main.port}"
  # }

  inbound_services          = []
  handlers {
    auth_fail_action = "AUTH_FAIL_ACTION_REDIRECT"
    login            = "LOGIN_OPTIONAL"
    security_level   = "SECURE_OPTIONAL"
    url_regex        = ".*"

    script {
      script_path = "auto"
    }
  }

  noop_on_destroy           = true
  delete_service_on_destroy = true
}