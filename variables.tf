/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  description = "GKE Cluster project id."
  type        = string
}

variable "authenticator_security_group" {
  description = "RBAC security group for Google Groups for GKE, format is gke-security-groups@yourdomain.com."
  type        = string
  default     = null
}

variable "cluster_defaults" {
  description = "Default values for optional cluster configurations."
  type = object({
    cloudrun_config                 = bool
    database_encryption_key         = string
    enable_binary_authorization     = bool
    master_authorized_ranges        = map(string)
    max_pods_per_node               = number
    pod_security_policy             = bool
    release_channel                 = string
    vertical_pod_autoscaling        = bool
    gcp_filestore_csi_driver_config = bool
  })
  default = {
    # TODO: review defaults
    cloudrun_config             = false
    database_encryption_key     = null
    enable_binary_authorization = false
    master_authorized_ranges = {
      rfc1918_1 = "10.0.0.0/8"
      rfc1918_2 = "172.16.0.0/12"
      rfc1918_3 = "192.168.0.0/16"
    }
    max_pods_per_node               = 110
    pod_security_policy             = false
    release_channel                 = "STABLE"
    vertical_pod_autoscaling        = false
    gcp_filestore_csi_driver_config = false
  }
}

variable "cluster" {
  description = ""
  type = object({
    name = string
    cluster_autoscaling = object({
      cpu_min    = number
      cpu_max    = number
      memory_min = number
      memory_max = number
    })
    description = string
    /* dns_domain  = string */
    labels      = map(string)
    location    = string
    net = object({
      master_range = string
      pods         = string
      services     = string
      subnet       = string
    })
    overrides = object({
      cloudrun_config                 = bool
      database_encryption_key         = string
      enable_binary_authorization     = bool
      master_authorized_ranges        = map(string)
      max_pods_per_node               = number
      pod_security_policy             = bool
      release_channel                 = string
      vertical_pod_autoscaling        = bool
      gcp_filestore_csi_driver_config = bool
    })
  })
}

variable "network" {
  description = "Name or self link of the VPC used for the cluster. Use the self link for Shared VPC."
  type = string
}

