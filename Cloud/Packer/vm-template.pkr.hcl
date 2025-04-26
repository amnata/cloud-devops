source "googlecompute" "debian" {
  project_id              = var.project_id
  source_image_family     = var.source_image_family
  source_image_project_id = var.source_image_project_id
  zone                    = var.zone
  machine_type            = var.machine_type
  ssh_username            = var.ssh_username
  image_name              = var.custom_image_default_name
  image_family            = var.image_family
  disk_size               = var.disk_size
  use_internal_ip         = false
}

build {
  name    = "gcp-debian-image"
  sources = ["source.googlecompute.debian"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get install -y nginx"
    ]
  }
}
