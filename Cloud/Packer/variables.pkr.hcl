variable "project_id" {
  type = string
}

variable "source_image_family" {
  type    = string
  default = "debian-11"
}

variable "source_image_project_id" {
  type    = list(string)
  default = ["debian-cloud"]
}

variable "custom_image_default_name" {
  type    = string
  default = "custom-debian-template"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "ssh_username" {
  type    = string
  default = "packer"
}

variable "image_name" {
  type    = string
  default = ""
}

variable "image_family" {
  type    = string
  default = "custom-image-family"
}

variable "disk_size" {
  type    = number
  default = 10
}
variable "credentials_file" {
  type = string
}
