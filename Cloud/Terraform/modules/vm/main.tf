

# Create a GCP Compute Engine VM instance
resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "${var.image_project}/${var.image_family}"
      size  = 20 # GB
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnet

    dynamic "access_config" {
      for_each = var.allow_public_ip ? [1] : []
      content {
        // Ephemeral IP
      }
    }
  }

  metadata = {
    startup-script = var.startup_script
  }

  tags = var.tags

  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }

  // Optional: Allow stopping for update
  allow_stopping_for_update = true

  // Optional: Shielded VM configuration
  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
}


