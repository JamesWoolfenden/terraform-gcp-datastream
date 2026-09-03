# Datastream reads the source password from Secret Manager at connection time,
# so its service agent needs accessor on the secret holding it.
resource "google_secret_manager_secret_iam_member" "datastream_service_agent" {
  secret_id = split("/versions/", var.source_password_secret_version)[0]
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_project_service_identity.datastream.email}"
}
