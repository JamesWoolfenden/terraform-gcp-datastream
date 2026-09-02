# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
# holden:ignore:HLD_TF_065: for expansion
module "datastream" {
  source          = "../../"
  stream_id       = "example-stream"
  location        = "europe-west2"
  network         = google_compute_network.datastream.id
  peering_subnet  = "10.80.0.0/29"
  source_hostname = "10.90.0.10"
  source_username = "datastream"
  source_password = var.source_password
  source_database = "example"
  kms_key_name    = google_kms_crypto_key.datastream.id

  depends_on = [google_kms_crypto_key_iam_member.datastream_service_agent]
}
