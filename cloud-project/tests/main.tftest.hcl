# Lancer avec : terraform test
# Ces tests utilisent "plan" : aucune ressource n'est créée.

variables {
  project_name   = "cloud-project"
  environment    = "dev"
  aws_region     = "us-east-1"
  floci_endpoint = "http://localhost:4566"
}

run "noms_en_dev" {
  command = plan

  assert {
    condition     = output.storage_name == "cloud-project-dev-bucket"
    error_message = "Le nom du bucket dev est incorrect."
  }

  assert {
    condition     = output.database_name == "cloud-project-dev-table"
    error_message = "Le nom de la table dev est incorrect."
  }
}

run "noms_en_prod" {
  command = plan

  variables {
    environment = "prod"
  }

  assert {
    condition     = output.storage_name == "cloud-project-prod-bucket"
    error_message = "Le nom du bucket prod est incorrect."
  }
}

run "environnement_invalide_refuse" {
  command = plan

  variables {
    environment = "staging"
  }

  expect_failures = [var.environment]
}

run "nom_de_projet_invalide_refuse" {
  command = plan

  variables {
    project_name = "Mon_Projet"
  }

  expect_failures = [var.project_name]
}
