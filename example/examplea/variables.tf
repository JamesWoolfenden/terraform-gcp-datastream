# holden:ignore:HLD_TF_050: holds a Secret Manager version resource name, not a
# credential — the value is deliberately non-secret, which is the whole point of
# passing it instead of the password
variable "source_password_secret_version" {
  type        = string
  description = "Secret Manager version holding the password of the replication user on the source MySQL server, e.g. projects/p/secrets/mysql-replication/versions/latest"

  validation {
    condition     = can(regex("^projects/[^/]+/secrets/[^/]+/versions/[^/]+$", var.source_password_secret_version))
    error_message = "var.source_password_secret_version must be a Secret Manager version name"
  }
}
