resource "google_datastream_connection_profile" "source" {
  display_name          = "${var.stream_id}-source"
  location              = var.location
  connection_profile_id = "${var.stream_id}-source"

  mysql_profile {
    hostname = var.source_hostname
    port     = var.source_port
    username = var.source_username
    password = var.source_password
  }

  private_connectivity {
    private_connection = google_datastream_private_connection.main.id
  }
}
