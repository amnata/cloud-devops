
resource "google_compute_instance" "custom_vm" {
  name         = "my-custom-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "projects/${var.project_id}/global/images/custom-debian-template"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Ephemeral public IP
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    echo "Hello from custom image!" > /var/www/html/index.html
  EOT

  tags = ["http-server"]
}

resource "google_compute_firewall" "default_allow_http" {
  name    = "default-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}
