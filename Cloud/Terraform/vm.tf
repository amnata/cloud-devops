module "ubuntuvm" {
  source          = "./modules/vm"
  vm_name         = "my-ubuntu-vm"
  machine_type    = "e2-medium"
  zone            = "us-central1-a"
  allow_public_ip = true
  tags            = ["http-server", "https-server"]
}

module "ubuntuvm2" {
  source          = "./modules/vm"
  vm_name         = "my-ubuntu-vm2"
  machine_type    = "e2-medium"
  zone            = "us-central1-a"
  allow_public_ip = true
  tags            = ["http-server", "https-server"]
}