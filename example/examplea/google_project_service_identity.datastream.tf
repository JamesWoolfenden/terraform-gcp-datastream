resource "google_project_service_identity" "datastream" {
  provider = google-beta
  service  = "datastream.googleapis.com"
}
