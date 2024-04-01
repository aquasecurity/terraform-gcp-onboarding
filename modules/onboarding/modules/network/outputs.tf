# modules/onboarding/modules/network/outputs.tf

output "network_name" {
  value       = google_compute_network.network.name
  description = "The name of the created VPC network"
}

output "firewall_name" {
  value       = google_compute_firewall.firewall.name
  description = "The name of the created firewall rule"
}
