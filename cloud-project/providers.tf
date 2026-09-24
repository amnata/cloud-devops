# Terraform parle à Floci (endpoint local) et non au vrai AWS.
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  # Floci n'a pas de vrai IAM/STS : on désactive les vérifications AWS réelles
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  # Les buckets sont adressés en /nom-du-bucket (pas nom.localhost)
  s3_use_path_style = true

  endpoints {
    s3       = var.floci_endpoint
    dynamodb = var.floci_endpoint
  }
}
