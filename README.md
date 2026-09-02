# terraform-gcp-datastream

[![Build Status](https://github.com/JamesWoolfenden/terraform-gcp-datastream/workflows/Verify/badge.svg?branch=master)](https://github.com/JamesWoolfenden/terraform-gcp-datastream)
[![Latest Release](https://img.shields.io/github/release/terraform-gcp-datastream.svg)](https://github.com/JamesWoolfenden/terraform-gcp-datastream/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/JamesWoolfenden/terraform-gcp-datastream.svg?label=latest)](https://github.com/JamesWoolfenden/terraform-gcp-datastream/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D1.5.0-blue.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

Terraform module for a CMEK-encrypted Datastream stream replicating MySQL CDC
into BigQuery over a private connection. Exercises holden's
`google_datastream_stream` policies.

## Usage

Add **module.datastream.tf** to your code:-

```terraform
module "datastream" {
  source          = "jameswoolfenden/datastream/gcp"
  version         = "0.0.1"
  stream_id       = "example-stream"
  location        = "europe-west2"
  network         = google_compute_network.datastream.id
  peering_subnet  = "10.80.0.0/29"
  source_hostname = "10.90.0.10"
  source_username = "datastream"
  source_password = var.source_password
  source_database = "example"
  kms_key_name    = google_kms_crypto_key.datastream.id
}
```

The stream reaches the source over a VPC peering private connection, so
`var.peering_subnet` must be an unused `/29` that does not overlap anything on
`var.network`, and the source must allow the peered range through its
firewall.

`var.source_password` is marked sensitive and enforced at 12 characters, but
it still lands in state — read it from Secret Manager in the calling
configuration rather than committing a literal.

Both the stream and the BigQuery datasets it creates are encrypted with
`var.kms_key_name`; the Datastream and BigQuery service agents each need
`roles/cloudkms.cryptoKeyEncrypterDecrypter` on it.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google_datastream_connection_profile.destination](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/datastream_connection_profile) | resource |
| [google_datastream_connection_profile.source](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/datastream_connection_profile) | resource |
| [google_datastream_private_connection.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/datastream_private_connection) | resource |
| [google_datastream_stream.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/datastream_stream) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_data_freshness"></a> [data\_freshness](#input\_data\_freshness) | How stale BigQuery data may be, in seconds with an s suffix | `string` | `"900s"` | no |
| <a name="input_desired_state"></a> [desired\_state](#input\_desired\_state) | State the stream should be in | `string` | `"RUNNING"` | no |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | Resource name of the Cloud KMS key used to encrypt the stream and the datasets it creates (CMEK) | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels applied to the stream | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Region of the stream, its connection profiles and the destination datasets | `string` | `"europe-west2"` | no |
| <a name="input_network"></a> [network](#input\_network) | Self-link of the VPC network Datastream peers with to reach the source database | `string` | n/a | yes |
| <a name="input_peering_subnet"></a> [peering\_subnet](#input\_peering\_subnet) | Unused /29 CIDR range Datastream uses for the peering connection | `string` | n/a | yes |
| <a name="input_source_database"></a> [source\_database](#input\_source\_database) | MySQL database replicated by the stream | `string` | n/a | yes |
| <a name="input_source_hostname"></a> [source\_hostname](#input\_source\_hostname) | Hostname or private IP of the source MySQL server | `string` | n/a | yes |
| <a name="input_source_password"></a> [source\_password](#input\_source\_password) | Password of the replication user, supply from Secret Manager rather than a literal | `string` | n/a | yes |
| <a name="input_source_port"></a> [source\_port](#input\_source\_port) | Port of the source MySQL server | `number` | `3306` | no |
| <a name="input_source_username"></a> [source\_username](#input\_source\_username) | Replication user on the source MySQL server | `string` | n/a | yes |
| <a name="input_stream_id"></a> [stream\_id](#input\_stream\_id) | Identifier of the Datastream stream, also used as the prefix for its connection profiles | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_private_connection_id"></a> [private\_connection\_id](#output\_private\_connection\_id) | ID of the Datastream private connection |
| <a name="output_state"></a> [state](#output\_state) | Current state of the stream |
| <a name="output_stream_id"></a> [stream\_id](#output\_stream\_id) | ID of the Datastream stream |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Help

**Got a question?**

File a GitHub [issue](https://github.com/JamesWoolfenden/terraform-gcp-datastream/issues).

## Copyrights

Copyright © 2019-2026 [Jim Woolfenden](https://github.com/JamesWoolfenden)

## License

See [LICENSE](LICENSE) for full details.


<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang
# apply role
resource "google_project_iam_custom_role" "terraform_pike" {
  project     = "pike-477416"
  role_id     = "terraform_pike"
  title       = "terraform_pike"
  description = "A user with least privileges"
  permissions = [
    "datastream.connectionProfiles.create",
    "datastream.connectionProfiles.delete",
    "datastream.connectionProfiles.get",
    "datastream.connectionProfiles.update",
    "datastream.privateConnections.create",
    "datastream.privateConnections.delete",
    "datastream.privateConnections.get",
    "datastream.streams.create",
    "datastream.streams.delete",
    "datastream.streams.get",
    "datastream.streams.update"
  ]
}

# plan role
resource "google_project_iam_custom_role" "terraform_pike_plan" {
  project     = "pike-477416"
  role_id     = "terraform_pike_plan"
  title       = "terraform_pike_plan"
  description = "A user with least privileges"
  permissions = [
    "datastream.connectionProfiles.get",
    "datastream.privateConnections.get",
    "datastream.streams.get"
  ]
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->