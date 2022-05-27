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

variable "cluster_name" {
  description = "	Cluster name."
  type        = string
}

variable "cluster_description" {
  description = "Cluster description."
  type        = string
}

variable "cluster_location" {
  description = "	Cluster zone or region."
  type        = string
}

variable "labels" {
  description = "Cluster resource labels."
  type        = map(string)
}


variable "network" {
  description = "Name or self link of the VPC used for the cluster. Use the self link for Shared VPC."
  type        = string
}


variable "subnetwork" {
  description = "VPC subnetwork name or self link."
  type        = string
}

variable "secondary_range_pods" {
  description = "Subnet secondary range name used for pods."
  type        = string
}

variable "secondary_range_services" {
  description = "Subnet secondary range name used for pods."
  type        = string
}

variable "cluster_autoscaling" {
  description = "Enable and configure limits for Node Auto-Provisioning with Cluster Autoscaler."
  type = object({
    enabled    = bool
    cpu_min    = number
    cpu_max    = number
    memory_min = number
    memory_max = number
  })
  default = {
    enabled    = false
    cpu_min    = 0
    cpu_max    = 0
    memory_min = 0
    memory_max = 0
  }
}

variable "horizontal_pod_autoscaling" {
  description = "Set to true to enable horizontal pod autoscaling"
  type        = bool
}

variable "vertical_pod_autoscaling" {
  description = "Set to true to enable vertical pod autoscaling"
  type        = bool
}

variable "database_encryption_key" {
  description = "Database Encryption Key name to	enable and configure GKE application-layer secrets encryption."
  type        = string
}

variable "private_cluster_config" {
  description = "Enable and configure private cluster, private nodes must be true if used."
  type = object({
    enable_private_nodes    = bool
    enable_private_endpoint = bool
    master_ipv4_cidr_block  = string //The IP range in CIDR notation to use for the hosted master network
    master_global_access    = bool
  })
}

variable "master_authorized_ranges" {
  description = "External Ip address ranges that can access the Kubernetes cluster master through HTTPS.."
  type        = map(string)
}

variable "enable_binary_authorization" {
  description = "Enable Google Binary Authorization."
  type        = bool
}