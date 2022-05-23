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
 
locals {
  cluster = merge(var.cluster,{
    overrides = coalesce(var.cluster.overrides, var.cluster_defaults)
    })
}

module "gke-cluster" {
  source = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/gke-cluster?ref=v15.0.0"
  name                     = local.cluster.name  
  project_id               = var.project_id
  description              = local.cluster.description
  location                 = local.cluster.location
  network                  = var.network
  subnetwork               = local.cluster.net.subnet
  secondary_range_pods     = local.cluster.net.pods
  secondary_range_services = local.cluster.net.services
  labels                   = local.cluster.labels
  addons = {
    cloudrun_config                       = local.cluster.overrides.cloudrun_config
    dns_cache_config                      = true
    http_load_balancing                   = true
    gce_persistent_disk_csi_driver_config = true
    horizontal_pod_autoscaling            = true
    config_connector_config               = true
    kalm_config                           = false
    gcp_filestore_csi_driver_config       = false
    # enable only if enable_dataplane_v2 is changed to false below
    network_policy_config = false
    istio_config = {
      enabled = false
      tls     = false
    }
  }
  # change these here for all clusters if absolutely needed
  authenticator_security_group = var.authenticator_security_group
  enable_dataplane_v2          = true
  enable_l4_ilb_subsetting     = false
  enable_intranode_visibility  = true
  enable_shielded_nodes        = true
  workload_identity            = true
  private_cluster_config = {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = local.cluster.net.master_range
    master_global_access    = true
  }
  logging_config    = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  monitoring_config = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  database_encryption = (
    local.cluster.overrides.database_encryption_key == null ? {
      enabled  = false
      state    = null
      key_name = null
      } : {
      enabled  = true
      state    = "ENCRYPTED"
      key_name = var.cluster.overrides.database_encryption_key
    }
  )
  default_max_pods_per_node   = local.cluster.overrides.max_pods_per_node
  enable_binary_authorization = local.cluster.overrides.enable_binary_authorization
  master_authorized_ranges    = local.cluster.overrides.master_authorized_ranges
  pod_security_policy         = local.cluster.overrides.pod_security_policy
  release_channel             = local.cluster.overrides.release_channel
  vertical_pod_autoscaling    = local.cluster.overrides.vertical_pod_autoscaling

}