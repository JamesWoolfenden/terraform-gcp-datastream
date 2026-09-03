locals {
  # Namespaces the BigQuery datasets Datastream derives from source schema
  # names, so two streams sharing a schema name cannot collide on one dataset.
  dataset_id_prefix = coalesce(var.dataset_id_prefix, "${replace(var.stream_id, "-", "_")}_")

  # Exactly one of backfill_all/backfill_none must be present on the stream.
  backfill_all  = var.backfill.strategy == "all" ? [1] : []
  backfill_none = var.backfill.strategy == "none" ? [1] : []

  # Only meaningful under backfill_all; a single-element list carrying the
  # excluded databases, or empty to omit the block entirely.
  backfill_exclusions = var.backfill.strategy == "all" && length(var.backfill.excluded_databases) > 0 ? [var.backfill.excluded_databases] : []
}
