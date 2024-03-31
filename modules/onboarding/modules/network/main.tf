# modules/onboarding/modules/network/main.tf

# Create a VPC network
resource "google_compute_network" "network" {
  name                    = var.network_name
  auto_create_subnetworks = true
  routing_mode            = "GLOBAL"
  project                 = var.project_id
}

# Create a firewall rule to allow egress traffic on port 443
#tfsec:ignore:google-compute-no-public-egress
resource "google_compute_firewall" "firewall" {
  name    = var.firewall_name
  project = var.project_id
  network = google_compute_network.network.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  direction = "EGRESS"
}