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

module "gke-cluster" {
  source                   = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/gke-cluster?ref=v15.0.0"
  project_id               = var.project_id
  name                     = var.cluster_name
  description              = var.cluster_description
  location                 = var.cluster_location
  labels                   = var.labels
  network                  = var.network
  subnetwork               = var.subnetwork
  secondary_range_pods     = var.secondary_range_pods
  secondary_range_services = var.secondary_range_services
  cluster_autoscaling      = var.cluster_autoscaling
  addons = {
    cloudrun_config                       = false
    dns_cache_config                      = true
    http_load_balancing                   = true
    gce_persistent_disk_csi_driver_config = true
    horizontal_pod_autoscaling            = var.horizontal_pod_autoscaling
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
  private_cluster_config = var.private_cluster_config
  logging_config         = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  monitoring_config      = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  database_encryption = (
    var.database_encryption_key == null ? {
      enabled  = false
      state    = null
      key_name = null
      } : {
      enabled  = true
      state    = "ENCRYPTED"
      key_name = var.database_encryption_key
    }
  )
  enable_binary_authorization = var.enable_binary_authorization
  master_authorized_ranges    = var.master_authorized_ranges
  vertical_pod_autoscaling    = var.vertical_pod_autoscaling

}