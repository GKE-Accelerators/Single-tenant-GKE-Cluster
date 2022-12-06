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
  database_encryption = var.database_encryption_key == null ? null : {
    state    = "ENCRYPTED"
    key_name = var.database_encryption_key
  }

  auto_provisioning = var.cluster_autoscaling.enabled? {
    auto_provisioning_defaults = {},
    cpu_limits = {
      min = var.cluster_autoscaling.cpu_min,
      max = var.cluster_autoscaling.cpu_max,
    },
    mem_limits = {
      min = var.cluster_autoscaling.memory_min,
      max = var.cluster_autoscaling.memory_max,
    }

  } : null
}

module "gke-cluster" {
  source      = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/gke-cluster"
  project_id  = var.project_id
  name        = var.cluster_name
  description = var.cluster_description
  location    = var.cluster_location
  labels      = var.labels

  cluster_autoscaling = local.auto_provisioning
  vpc_config = {
    network    = var.network
    subnetwork = var.subnetwork
    master_ipv4_cidr_block = var.master_ipv4_cidr_block
    secondary_range_names = {
      pods                     = var.secondary_range_pods
      services                 = var.secondary_range_services
    }
      master_authorized_ranges = var.master_authorized_ranges

  }
  enable_addons = {
    cloudrun                       = false
    dns_cache                      = true
    http_load_balancing            = true
    gce_persistent_disk_csi_driver = true
    horizontal_pod_autoscaling     = var.horizontal_pod_autoscaling
    config_connector               = true
    kalm                           = false
    gcp_filestore_csi_driver       = false
    network_policy                 = false
    istio = {
      enable_tls = false
    }
  }
  enable_features = {
    binary_authorization = var.enable_binary_authorization
    database_encryption  = local.database_encryption
workload_identity = true
    vertical_pod_autoscaling = var.vertical_pod_autoscaling

  }
  private_cluster_config = var.private_cluster_config
  monitoring_config = {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
  logging_config = ["SYSTEM_COMPONENTS", "WORKLOADS"]

  max_pods_per_node = var.default_max_pods_per_node
}

module "nodepool" {
  source       = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/gke-nodepool"
  project_id   = var.project_id
  cluster_name = module.gke-cluster.name
  location     = var.cluster_location
  name         = "${module.gke-cluster.name}-np"
  node_count = {
    initial = 1,
  }
  nodepool_config = {
    min_node_count = 5
    max_node_count = 20
  }
}

module "gke-gateway-api" {
  source         = "./modules/gateway-api"
  endpoint       = module.gke-cluster.endpoint
  ca_certificate = module.gke-cluster.ca_certificate
}

# Register the cluster to Anthos configuration manager
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke-cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke-cluster.ca_certificate)
}

module "acm" {
  source       = "terraform-google-modules/kubernetes-engine/google//modules/acm"
  project_id   = var.project_id
  cluster_name = module.gke-cluster.name
  location     = module.gke-cluster.location
  sync_repo    = var.sync_repo
  sync_branch  = var.sync_branch
  policy_dir   = var.policy_dir

  depends_on = [module.nodepool]
}


