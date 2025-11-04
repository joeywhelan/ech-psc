output "elastic_external_endpoint" {
  value = ec_deployment.primary.elasticsearch.https_endpoint
}

output "elastic_cloud_id" {
  value = ec_deployment.primary.elasticsearch.cloud_id
}

output "elastic_username" {
  value = ec_deployment.primary.elasticsearch_username
}

output "elastic_password" {
  value     = ec_deployment.primary.elasticsearch_password
  sensitive = true
}

output "elastic_index_name" {
  value = var.elastic_index_name
}

output "elastic_psc_ip_address" {
  value = google_compute_address.psc_endpoint.address
}

locals {
  alias = regex("^(https://[^.]+)", ec_deployment.primary.elasticsearch.https_endpoint)[0]
  psc_dns = trimsuffix(var.elastic_central_psc_dns_name, ".")
}

output "elastic_psc_endpoint" {
  value = "${local.alias}.${local.psc_dns}"
}

output "central_vm_name" {
  description = "Name of the VM instance"
  value       = google_compute_instance.central_vm.id
}

output "central_vm_internal_ip" {
  description = "Internal IP address of the VM"
  value       = google_compute_instance.central_vm.network_interface[0].network_ip
}

output "central_vm_external_ip" {
  description = "External IP address of the VM"
  value       = google_compute_instance.central_vm.network_interface[0].access_config[0].nat_ip
}

output "central_vm_zone" {
  description = "Zone where the VM is located"
  value       = google_compute_instance.central_vm.zone
}

output "central_ssh_command_gcloud" {
  description = "Command to SSH using gcloud"
  value       = "gcloud compute ssh ${google_compute_instance.central_vm.name} --zone=${var.zone} --project=${var.project_id}"
}