# holden:ignore:HLD_GCP_303: peering-only VPC with no subnets or instances — Datastream
# traffic uses the peering, nothing egresses, and a 0.0.0.0/0 route to
# default-internet-gateway would reintroduce the path HLD_GCP_094 requires be deleted
# holden:ignore:HLD_GCP_544: same composition — nothing in the network resolves
# googleapis.com, so a private DNS zone would have no client
resource "google_compute_network" "datastream" {
  name                    = "datastream-network"
  auto_create_subnetworks = false

  # The network exists only to give Datastream a peering range; nothing in it
  # egresses, so no replacement route to the Google API VIPs is needed.
  delete_default_routes_on_create = true
}
