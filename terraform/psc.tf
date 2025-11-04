resource "google_compute_network" "psc_vpc" {
  name                    = "psc-vpc"
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "psc_subnet" {
  name          = "psc-subnet"
  ip_cidr_range = "10.1.0.0/24"
  region        = var.region
  network       = google_compute_network.psc_vpc.id
  project       = var.project_id
}

resource "google_compute_address" "psc_endpoint" {
  name         = "psc-endpoint"
  address_type = "INTERNAL"
  subnetwork   = google_compute_subnetwork.psc_subnet.id
  region       = var.region
  project      = var.project_id
}

resource "google_compute_forwarding_rule" "psc_forwarding_rule" {
  name                  = "psc-forwarding-rule"
  region                = var.region
  project               = var.project_id
  network               = google_compute_network.psc_vpc.id
  ip_address            = google_compute_address.psc_endpoint.id
  load_balancing_scheme = ""
  target                = var.elastic_central_psc_service_attachment
}

resource "google_dns_managed_zone" "elastic_cluster_zone" {
  name        = "elastic-cluster-zone"
  dns_name    = "${var.elastic_central_psc_dns_name}."
  description = "Private DNS zone for Elastic cluster"
  project     = var.project_id
  
  visibility = "private"
  
  private_visibility_config {
    networks {
      network_url = google_compute_network.psc_vpc.id
    }
  }
}

resource "google_dns_record_set" "elastic_record_set" {
  name         = "*.${var.elastic_central_psc_dns_name}."
  managed_zone = google_dns_managed_zone.elastic_cluster_zone.name
  type         = "A"
  ttl          = 300
  rrdatas = ["${google_compute_address.psc_endpoint.address}"]
}Basic Queries - Single Index