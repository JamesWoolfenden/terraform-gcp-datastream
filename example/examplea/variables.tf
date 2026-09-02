variable "source_password" {
  type        = string
  description = "Password of the replication user on the source MySQL server"
  sensitive   = true

  validation {
    condition     = length(var.source_password) >= 12
    error_message = "var.source_password must be at least 12 characters"
  }
}
