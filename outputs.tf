output "stream_id" {
  value       = google_datastream_stream.main.id
  description = "ID of the Datastream stream"
}

output "state" {
  value       = google_datastream_stream.main.state
  description = "Current state of the stream"
}

output "private_connection_id" {
  value       = google_datastream_private_connection.main.id
  description = "ID of the Datastream private connection"
}
