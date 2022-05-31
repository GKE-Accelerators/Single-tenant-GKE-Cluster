module "gke-cluster" {
  source                   = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/gke-cluster?ref=v15.0.0"
  name                     = "cluster-gke-generic"
  project_id               = "rovindsouza"
  description              = "description"
  location                 = "us-central1"
  network                  = "tempus-test"
  subnetwork               = "us-central-1"
  secondary_range_pods     = "pod"
  secondary_range_services = "services"
  labels                   = {env = "test"}
  addons = {
    cloudrun_config                       = false
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
  authenticator_security_group = "gke-security-groups@rovin.in"
  enable_dataplane_v2          = true
  enable_l4_ilb_subsetting     = false
  enable_intranode_visibility  = true
  enable_shielded_nodes        = true
  workload_identity            = true
  private_cluster_config = {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "10.1.0.0/28"
    master_global_access    = true
  }
#   dns_config = each.value.dns_domain == null ? null : {
#     cluster_dns        = "CLOUD_DNS"
#     cluster_dns_scope  = "VPC_SCOPE"
#     cluster_dns_domain = "test.rovin.in"
#   }
  logging_config    = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  monitoring_config = ["SYSTEM_COMPONENTS", "WORKLOADS"]

  # if you don't have compute.networks.updatePeering in the host
  # project, comment out the next line and ask your network admin to
  # create the peering for you
#   peering_config = {
#     export_routes = true
#     import_routes = false
#     project_id    = []
#   }
#   resource_usage_export_config = {
#     enabled = true
#     dataset = module.gke-dataset-resource-usage.dataset_id
#   }
  # TODO: the attributes below are "primed" from project-level defaults
  #       in locals, merge defaults with cluster-level stuff
  # TODO(jccb): change fabric module
#   database_encryption = (
#     each.value.overrides.database_encryption_key == null ? {
#       enabled  = false
#       state    = null
#       key_name = null
#       } : {
#       enabled  = true
#       state    = "ENCRYPTED"
#       key_name = each.value.overrides.database_encryption_key
#     }
#   )
  default_max_pods_per_node   = 10
  enable_binary_authorization = "false"
  master_authorized_ranges    = {open = "0.0.0.0/0"}
  pod_security_policy         = false
  release_channel             = "STABLE"
  vertical_pod_autoscaling    = false
  # dynamic "cluster_autoscaling" {
  #   for_each = each.value.cluster_autoscaling == null ? {} : { 1 = 1 }
  #   content {
  #     enabled    = true
  #     cpu_min    = each.value.cluster_autoscaling.cpu_min
  #     cpu_max    = each.value.cluster_autoscaling.cpu_max
  #     memory_min = each.value.cluster_autoscaling.memory_min
  #     memory_max = each.value.cluster_autoscaling.memory_max
  #   }
  # }


}