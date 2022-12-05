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
  default     = "my-cluster"
}

variable "cluster_description" {
  description = "Cluster description."
  type        = string
  default     = " This is a simple single tenant cluster"
}

variable "cluster_location" {
  description = "	Cluster zone or region."
  type        = string
  default     = "us-central1"
}

variable "labels" {
  description = "Cluster resource labels."
  type        = map(string)
  default     = { "env" : "test" }
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
    enabled    = true
    cpu_min    = 10
    cpu_max    = 80
    memory_min = 1024
    memory_max = 4096
  }
}

variable "horizontal_pod_autoscaling" {
  description = "Set to true to enable horizontal pod autoscaling"
  type        = bool
  default     = true
}

variable "vertical_pod_autoscaling" {
  description = "Set to true to enable vertical pod autoscaling"
  type        = bool
  default     = true
}

variable "database_encryption_key" {
  description = "Database Encryption Key name to	enable and configure GKE application-layer secrets encryption."
  type        = string
  default     = null
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation to use for the hosted master network"
  type = string
  default =  "192.168.1.0/28"

}  


variable "private_cluster_config" {
  description = "Enable and configure private cluster, private nodes must be true if used."
  type = object({
    enable_private_endpoint = bool
    master_global_access    = bool
  })
  default = {
    enable_private_endpoint = false
    master_global_access    = true
  }
}

variable "master_authorized_ranges" {
  description = "External Ip address ranges that can access the Kubernetes cluster master through HTTPS.."
  type        = map(string)
  default = {
    "public" = "0.0.0.0/0"
  }
}

variable "enable_binary_authorization" {
  description = "Enable Google Binary Authorization."
  type        = bool
  default     = false
}

variable "default_max_pods_per_node" {
  description = "Max nodes allowed per node."
  type        = number
  default     = 55
}

variable "sync_repo" {
  type        = string
  description = "ACM Git repo address	"
  default     = "https://github.com/GoogleCloudPlatform/acm-essentials"
}
variable "sync_branch" {
  type        = string
  description = "ACM repo Git branch. If un-set, uses Config Management default."
  default     = ""
}
variable "policy_dir" {
  type        = string
  description = "ACM repo Git revision. If un-set, uses Config Management default."
  default     = ""
}