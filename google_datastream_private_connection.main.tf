resource "google_datastream_private_connection" "main" {
  project               = var.project
  display_name          = "${var.stream_id}-private-connection"
  location              = var.location
  private_connection_id = "${var.stream_id}-private-connection"
  labels                = var.labels

  vpc_peering_config {
    vpc    = var.network
    subnet = var.peering_subnet
  }
}
