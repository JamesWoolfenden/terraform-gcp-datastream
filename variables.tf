variable "stream_id" {
  type        = string
  description = "Identifier of the Datastream stream, also used as the prefix for its connection profiles"

  validation {
    condition     = can(regex("^[a-z][-a-z0-9]{0,50}$", var.stream_id))
    error_message = "var.stream_id must be lowercase and start with a letter"
  }
}

variable "location" {
  type        = string
  description = "Region of the stream, its connection profiles and the destination datasets"
  default     = "europe-west2"

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "var.location must be a non-empty string"
  }
}

variable "kms_key_name" {
  type        = string
  description = "Resource name of the Cloud KMS key used to encrypt the stream and the datasets it creates (CMEK)"
  sensitive   = true

  validation {
    condition     = length(trimspace(var.kms_key_name)) > 0
    error_message = "var.kms_key_name must be a non-empty string"
  }
}

variable "network" {
  type        = string
  description = "Self-link of the VPC network Datastream peers with to reach the source database"

  validation {
    condition     = length(trimspace(var.network)) > 0
    error_message = "var.network must be a non-empty string"
  }
}

variable "peering_subnet" {
  type        = string
  description = "Unused /29 CIDR range Datastream uses for the peering connection"

  validation {
    condition     = can(regex("^[0-9.]+/29$", var.peering_subnet))
    error_message = "var.peering_subnet must be a /29 CIDR range"
  }
}

variable "source_databases" {
  type        = map(list(string))
  description = "MySQL databases replicated by the stream, keyed by database name; the value lists the tables to include, or an empty list for the whole database"

  validation {
    condition     = length(var.source_databases) > 0
    error_message = "var.source_databases must name at least one database"
  }

  validation {
    condition     = alltrue([for db in keys(var.source_databases) : length(trimspace(db)) > 0])
    error_message = "var.source_databases keys must be non-empty database names"
  }
}

variable "data_freshness" {
  type        = string
  description = "How stale BigQuery data may be, in seconds with an s suffix"
  default     = "900s"

  validation {
    condition     = can(regex("^[0-9]+s$", var.data_freshness))
    error_message = "var.data_freshness must be a duration in seconds, e.g. 900s"
  }
}

variable "dataset_id_prefix" {
  type        = string
  description = "Prefix for the BigQuery datasets Datastream creates per source schema, defaults to var.stream_id with hyphens replaced by underscores so two streams cannot collide on a shared schema name"
  default     = null

  validation {
    condition     = var.dataset_id_prefix == null ? true : can(regex("^[a-zA-Z0-9_]+$", var.dataset_id_prefix))
    error_message = "var.dataset_id_prefix must contain only letters, numbers and underscores"
  }
}

variable "desired_state" {
  type        = string
  description = "State the stream should be in"
  default     = "RUNNING"

  validation {
    condition     = contains(["RUNNING", "PAUSED", "NOT_STARTED"], var.desired_state)
    error_message = "var.desired_state must be RUNNING, PAUSED or NOT_STARTED"
  }
}

variable "labels" {
  type        = map(string)
  description = "Labels applied to the stream"
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.labels : can(regex("^[a-z][a-z0-9_-]{0,62}$", k))])
    error_message = "var.labels keys must be lowercase and start with a letter"
  }
}

variable "project" {
  type        = string
  description = "Project the stream and its connection profiles are created in, defaults to the provider project"
  default     = null

  validation {
    condition     = var.project == null ? true : length(trimspace(var.project)) > 0
    error_message = "var.project must be a non-empty string when set"
  }
}

variable "source_mysql" {
  type = object({
    hostname                       = string
    port                           = optional(number, 3306)
    username                       = string
    secret_manager_stored_password = string
  })
  description = "Connection details for the source MySQL server; the replication user's password is referenced as a Secret Manager version name so it never enters Terraform state"
  sensitive   = true

  validation {
    condition     = length(trimspace(var.source_mysql.hostname)) > 0
    error_message = "var.source_mysql.hostname must be a non-empty string"
  }

  validation {
    condition     = var.source_mysql.port > 0 && var.source_mysql.port < 65536
    error_message = "var.source_mysql.port must be a valid TCP port"
  }

  validation {
    condition     = length(trimspace(var.source_mysql.username)) > 0
    error_message = "var.source_mysql.username must be a non-empty string"
  }

  validation {
    condition     = can(regex("^projects/[^/]+/secrets/[^/]+/versions/[^/]+$", var.source_mysql.secret_manager_stored_password))
    error_message = "var.source_mysql.secret_manager_stored_password must be a Secret Manager version name, e.g. projects/p/secrets/s/versions/latest"
  }
}

variable "backfill" {
  type = object({
    strategy           = optional(string, "all")
    excluded_databases = optional(list(string), [])
  })
  description = "Historical backfill behaviour; strategy none starts from the current binlog position instead of a full read of the source"
  default     = {}

  validation {
    condition     = contains(["all", "none"], var.backfill.strategy)
    error_message = "var.backfill.strategy must be all or none"
  }

  validation {
    condition     = alltrue([for db in var.backfill.excluded_databases : length(trimspace(db)) > 0])
    error_message = "var.backfill.excluded_databases entries must be non-empty database names"
  }
}

variable "max_concurrent_tasks" {
  type = object({
    cdc      = optional(number)
    backfill = optional(number)
  })
  description = "Caps on the concurrent tasks Datastream runs against the source; unset attributes fall back to the Datastream server-side default"
  default     = {}

  validation {
    condition     = var.max_concurrent_tasks.cdc == null ? true : var.max_concurrent_tasks.cdc > 0
    error_message = "var.max_concurrent_tasks.cdc must be greater than zero when set"
  }

  validation {
    condition     = var.max_concurrent_tasks.backfill == null ? true : var.max_concurrent_tasks.backfill > 0
    error_message = "var.max_concurrent_tasks.backfill must be greater than zero when set"
  }
}
