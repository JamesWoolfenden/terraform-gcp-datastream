resource "google_kms_key_ring" "datastream" {
  name     = "datastream-keyring"
  location = "europe-west2"
}
