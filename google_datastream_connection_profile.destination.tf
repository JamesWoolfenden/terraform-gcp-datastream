resource "google_datastream_connection_profile" "destination" {
  project               = var.project
  display_name          = "${var.stream_id}-destination"
  location              = var.location
  connection_profile_id = "${var.stream_id}-destination"
  labels                = var.labels

  bigquery_profile {}
}
