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
  description = "Tags appliqués à la table"
  default     = {}
}

variable "hash_key" {
  type        = string
  description = "Nom de la clé de partition de la table"
  default     = "id"
}

variable "hash_key_type" {
  type        = string
  description = "Type de la clé de partition : S (string), N (number) ou B (binary)"
  default     = "S"

  validation {
    condition     = contains(["S", "N", "B"], var.hash_key_type)
    error_message = "hash_key_type doit valoir S, N ou B."
  }
}
