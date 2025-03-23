module "mybucket" {
  source          = "./modules/bucket"
  project_id      = "e-adept"
  bucket_name     = "test-bucket"
  region          = "us-central1"
  bucket_location = "US"
}