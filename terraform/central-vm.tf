resource "google_compute_firewall" "allow_ssh_vm" {
  name    = "allow-ssh-vm"
  network = google_compute_network.psc_vpc.id
  project = var.project_id
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-ssh"]
}

resource "google_compute_instance" "central_vm" {
  name         = "central-vm"
  machine_type = "e2-medium"
  zone         = var.zone
  project      = var.project_id
  
  tags = ["allow-ssh"]
  
  boot_disk {
    initialize_params {
      # Ubuntu 24.04 LTS
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      size  = 20
      type  = "pd-standard"
    }
  }
  
  network_interface {
    subnetwork = google_compute_subnetwork.psc_subnet.id
    
    # External IP for SSH access from internet
    access_config {
      # Ephemeral external IP
    }
  }
  
  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y curl wget git vim python3-pip python3-venv
    echo "VM setup complete" > /tmp/startup-complete.txt
  EOF
  
  # Service account with minimal permissions
  service_account {
    scopes = ["cloud-platform"]
  }
  
  # Allow stopping for maintenance
  allow_stopping_for_update = true
}
