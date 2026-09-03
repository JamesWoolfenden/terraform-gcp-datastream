# holden:ignore:HLD_TF_063_HIGH — score 18, of which 6 comes from the
# backfill_all > mysql_excluded_objects > mysql_databases nest. That depth is
# the provider schema's shape, not accidental logic: every conditional is
# already hoisted into locals.tf. Dropping backfill exclusions scores 12, at
# the cost of forcing a full historical read of every source database.
resource "google_datastream_stream" "main" {
  project                         = var.project
  stream_id                       = var.stream_id
  location                        = var.location
  display_name                    = var.stream_id
  desired_state                   = var.desired_state
  customer_managed_encryption_key = var.kms_key_name
  labels                          = var.labels

  source_config {
    source_connection_profile = google_datastream_connection_profile.source.id

    mysql_source_config {
      max_concurrent_cdc_tasks      = var.max_concurrent_tasks.cdc
      max_concurrent_backfill_tasks = var.max_concurrent_tasks.backfill

      include_objects {
        dynamic "mysql_databases" {
          for_each = var.source_databases

          content {
            database = mysql_databases.key

            dynamic "mysql_tables" {
              for_each = mysql_databases.value

              content {
                table = mysql_tables.value
              }
            }
          }
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
          location          = var.location
          kms_key_name      = var.kms_key_name
          dataset_id_prefix = local.dataset_id_prefix
        }
      }
    }
  }

  dynamic "backfill_all" {
    for_each = local.backfill_all

    content {
      dynamic "mysql_excluded_objects" {
        for_each = local.backfill_exclusions

        content {
          dynamic "mysql_databases" {
            for_each = mysql_excluded_objects.value

            content {
              database = mysql_databases.value
            }
          }
        }
      }
    }
  }

  dynamic "backfill_none" {
    for_each = local.backfill_none

    content {}
  }
}
