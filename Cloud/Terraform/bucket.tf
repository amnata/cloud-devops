resource "google_storage_bucket" "testbkt" {
  name          = "${local.project_id}-dic-bkt"
  project       = local.project_id
  location      = "US"
  force_destroy = true
}
