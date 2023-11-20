variable "project_id" {
  type        = string
  description = "The name of the GCP Project"
  default     = "rich-synapse-400718"
}

variable "region" {
  type        = string
  description = "The GCP Region for the GCP Project"
  default     = "us-east1"
}