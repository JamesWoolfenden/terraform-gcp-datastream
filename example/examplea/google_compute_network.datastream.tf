resource "google_compute_network" "datastream" {
  name                    = "datastream-network"
  auto_create_subnetworks = false
}
