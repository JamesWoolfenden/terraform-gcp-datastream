resource "google_datastream_private_connection" "main" {
  display_name          = "${var.stream_id}-private-connection"
  location              = var.location
  private_connection_id = "${var.stream_id}-private-connection"

  vpc_peering_config {
    vpc    = var.network
    subnet = var.peering_subnet
  }
}
