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
| <a name="input_allow_public_ip"></a> [allow\_public\_ip](#input\_allow\_public\_ip) | Whether to allow a public IP | `bool` | `true` | no |
| <a name="input_image_family"></a> [image\_family](#input\_image\_family) | Image family for the VM | `string` | `"ubuntu-2204-lts"` | no |
| <a name="input_image_project"></a> [image\_project](#input\_image\_project) | Project containing the VM image | `string` | `"ubuntu-os-cloud"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | Machine type for the VM instance | `string` | `"e2-medium"` | no |
| <a name="input_network"></a> [network](#input\_network) | Network for the VM | `string` | `"default"` | no |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | Service account email for the VM | `string` | `null` | no |
| <a name="input_service_account_scopes"></a> [service\_account\_scopes](#input\_service\_account\_scopes) | Scopes for the VM service account | `list(string)` | <pre>[<br/>  "cloud-platform"<br/>]</pre> | no |
| <a name="input_startup_script"></a> [startup\_script](#input\_startup\_script) | Startup script for the VM | `string` | `"apt install nginx -y"` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | Subnet for the VM | `string` | `"default"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Network tags for the VM | `list(string)` | <pre>[<br/>  "http-server",<br/>  "https-server"<br/>]</pre> | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | Name of the VM instance | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone where the VM will be created | `string` | `"us-central1-a"` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_external_ip"></a> [vm\_external\_ip](#output\_vm\_external\_ip) | n/a |
| <a name="output_vm_internal_ip"></a> [vm\_internal\_ip](#output\_vm\_internal\_ip) | Output the VM IP addresses |
<!-- END_TF_DOCS -->