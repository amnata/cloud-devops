variable "name" {
  type        = string
  description = "Préfixe de nommage pour les ressources"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "name doit contenir uniquement des minuscules, chiffres et tirets."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags appliqués au bucket"
  default     = {}
}

variable "versioning_enabled" {
  type        = bool
  description = "Active le versioning du bucket"
  default     = false
}

variable "force_destroy" {
  type        = bool
  description = "Autorise la suppression du bucket même s'il contient des objets"
  default     = true
}
