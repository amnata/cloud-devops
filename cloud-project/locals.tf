locals {
  # Préfixe de nommage commun à toutes les ressources
  resource_prefix = "${var.project_name}-${var.environment}"

  # Vrai uniquement en environnement prod
  is_prod = var.environment == "prod"

  # Tags communs, fusionnés avec les tags optionnels de l'utilisateur
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.extra_tags
  )
}
