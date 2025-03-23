resource "google_project_service" "compute" {
  project            = local.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}
