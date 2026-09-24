module "storage" {
  source = "./modules/storage"

  name               = local.resource_prefix
  tags               = local.common_tags
  versioning_enabled = local.is_prod # versioning activé seulement en prod
}

module "database" {
  source = "./modules/database"

  name = local.resource_prefix
  tags = local.common_tags
}
