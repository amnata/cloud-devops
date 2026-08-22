module "mybucket" {
  source          = "./modules/bucket"
  project_id      = local.project_id
  bucket_name     = "test-bucket"
  region          = "us-central1"
  bucket_location = "US"
}