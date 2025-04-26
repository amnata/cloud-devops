<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.
## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_location"></a> [bucket\_location](#input\_bucket\_location) | The location of the bucket | `string` | `"US"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the GCS bucket | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the GCP project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region dd to deploy resources | `string` | `"us-central1"` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | The storage class of the bucket | `string` | `"STANDARD"` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_url"></a> [bucket\_url](#output\_bucket\_url) | Output the bucket URL |
<!-- END_TF_DOCS -->