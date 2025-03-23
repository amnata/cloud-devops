
# Create a GCS bucket
resource "google_storage_bucket" "bucket" {
  name          = "${var.project_id}-${var.bucket_name}"
  location      = var.bucket_location
  storage_class = var.storage_class
  force_destroy = true
  # Optional: Set uniform bucket-level access
  uniform_bucket_level_access = true

  # Optional: Configure versioning
  versioning {
    enabled = true
  }

  # Optional: Set lifecycle rules (e.g., delete objects after 30 days)
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}
