resource "google_datastream_connection_profile" "destination" {
  display_name          = "${var.stream_id}-destination"
  location              = var.location
  connection_profile_id = "${var.stream_id}-destination"

  bigquery_profile {}
}
