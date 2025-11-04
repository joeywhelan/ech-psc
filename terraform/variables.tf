# ============================================
# ELASTIC VARIABLES
# ============================================

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "elastic_cloud_api_key" {
  description = "Elastic Cloud API key"
  type        = string
  sensitive   = true
}

variable "deployment_template_id" {
  description = "Elastic Cloud deployment template"
  type        = string
  default     = "gcp-general-purpose"

  validation {
    condition = contains([
      "gcp-storage-optimized",
      "gcp-compute-optimized",
      "gcp-general-purpose"
    ], var.deployment_template_id)
    error_message = "Must be a valid GCP deployment template"
  }
}

variable "elastic_central_psc_service_attachment" {
  description = "Service attachment URI for central Elastic cluster"
  type        = string
}

variable "elastic_central_psc_dns_name" {
  description = "Private DNS zone Elastic cluster"
  type        = string  
} 

variable "elastic_index_name" {
  description = "Index name"
  type        = string  
  default     = "test-index"
} 

# ============================================
# GCP Variables
# ============================================

variable "region" {
  description = "GCP region for Elastic cluster"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "us-central1-a"
}