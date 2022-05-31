terraform {
  backend "gcs" {
    bucket = "rovindsouza-303505-terraform-state"
    prefix = "gke/single-tenant"
  }
}