# Variables for VM configuration
variable "vm_name" {
  description = "Name of the VM instance"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the VM instance"
  type        = string
  default     = "e2-medium"
}

variable "zone" {
  description = "Zone where the VM will be created"
  type        = string
  default     = "us-central1-a"
}

variable "image_family" {
  description = "Image family for Google  VM"
  type        = string
  default     = "ubuntu-2204-lts" # Ubuntu 22.04 LTS
}

variable "image_project" {
  description = " VM image Project"
  type        = string
  default     = "ubuntu-os-cloud" # Ubuntu images project
}

variable "network" {
  description = "Network for the VM"
  type        = string
  default     = "default"
}

variable "subnet" {
  description = "Subnet for the VM"
  type        = string
  default     = "default"
}

variable "allow_public_ip" {
  description = "Whether to allow a public IP"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Network tags for the VM"
  type        = list(string)
  default     = ["http-server", "https-server"]
}

variable "startup_script" {
  description = "Startup script for the VM"
  type        = string
  default     = "apt install nginx -y"
}

variable "service_account_email" {
  description = "Service account email for the VM"
  type        = string
  default     = null
}

variable "service_account_scopes" {
  description = "Scopes for the VM service account"
  type        = list(string)
  default     = ["cloud-platform"]
}