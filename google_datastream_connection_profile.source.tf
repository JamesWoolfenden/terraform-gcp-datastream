resource "google_datastream_connection_profile" "source" {
  project               = var.project
  display_name          = "${var.stream_id}-source"
  location              = var.location
  connection_profile_id = "${var.stream_id}-source"
  labels                = var.labels

  mysql_profile {
    hostname                       = var.source_mysql.hostname
    port                           = var.source_mysql.port
    username                       = var.source_mysql.username
    secret_manager_stored_password = var.source_mysql.secret_manager_stored_password
  }

  private_connectivity {
    private_connection = google_datastream_private_connection.main.id
  }
}
