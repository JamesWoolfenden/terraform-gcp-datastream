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

variable "source_hostname" {
  type        = string
  description = "Hostname or private IP of the source MySQL server"

  validation {
    condition     = length(trimspace(var.source_hostname)) > 0
    error_message = "var.source_hostname must be a non-empty string"
  }
}

variable "source_port" {
  type        = number
  description = "Port of the source MySQL server"
  default     = 3306

  validation {
    condition     = var.source_port > 0 && var.source_port < 65536
    error_message = "var.source_port must be a valid TCP port"
  }
}

variable "source_username" {
  type        = string
  description = "Replication user on the source MySQL server"
  sensitive   = true

  validation {
    condition     = length(trimspace(var.source_username)) > 0
    error_message = "var.source_username must be a non-empty string"
  }
}

variable "source_password" {
  type        = string
  description = "Password of the replication user, supply from Secret Manager rather than a literal"
  sensitive   = true

  validation {
    condition     = length(var.source_password) >= 12
    error_message = "var.source_password must be at least 12 characters"
  }
}

variable "source_database" {
  type        = string
  description = "MySQL database replicated by the stream"

  validation {
    condition     = length(trimspace(var.source_database)) > 0
    error_message = "var.source_database must be a non-empty string"
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
