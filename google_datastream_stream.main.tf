resource "google_datastream_stream" "main" {
  stream_id                       = var.stream_id
  location                        = var.location
  display_name                    = var.stream_id
  desired_state                   = var.desired_state
  customer_managed_encryption_key = var.kms_key_name

  source_config {
    source_connection_profile = google_datastream_connection_profile.source.id

    mysql_source_config {
      include_objects {
        mysql_databases {
          database = var.source_database
        }
      }
    }
  }

  destination_config {
    destination_connection_profile = google_datastream_connection_profile.destination.id

    bigquery_destination_config {
      data_freshness = var.data_freshness

      source_hierarchy_datasets {
        dataset_template {
          location     = var.location
          kms_key_name = var.kms_key_name
        }
      }
    }
  }

  backfill_all {}

  labels = var.labels
}
