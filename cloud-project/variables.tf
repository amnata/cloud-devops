variable "project_name" {
  type        = string
  description = "Nom du projet (minuscules, chiffres, tirets : règle de nommage S3)"

  validation {
    condition     = can(regex("^[a-z0-9-]{3,30}$", var.project_name))
    error_message = "project_name doit contenir 3 à 30 caractères : minuscules, chiffres et tirets uniquement."
  }
}

variable "environment" {
  type        = string
  description = "Environnement de déploiement (dev ou prod)"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment doit valoir \"dev\" ou \"prod\"."
  }
}

variable "aws_region" {
  type        = string
  description = "Région AWS simulée par Floci"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "aws_region doit ressembler à us-east-1 ou eu-west-3."
  }
}

variable "floci_endpoint" {
  type        = string
  description = "Endpoint local de Floci (port AWS : 4566)"

  validation {
    condition     = can(regex("^https?://", var.floci_endpoint))
    error_message = "floci_endpoint doit commencer par http:// ou https://."
  }
}

variable "aws_access_key" {
  type        = string
  description = "Clé d'accès factice acceptée par Floci"
  default     = "test"
}

variable "aws_secret_key" {
  type        = string
  description = "Clé secrète factice acceptée par Floci"
  default     = "test"
  sensitive   = true
}

variable "extra_tags" {
  type        = map(string)
  description = "Tags supplémentaires appliqués à toutes les ressources"
  default     = {}
}
