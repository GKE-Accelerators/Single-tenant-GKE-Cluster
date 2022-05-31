project_id               = ""
cluster_name             = ""
cluster_description      = ""
cluster_location         = ""
labels                   = {}
network                  = ""
subnetwork               = ""
secondary_range_pods     = ""
secondary_range_services = ""
cluster_autoscaling = {
  enabled    = null
  cpu_min    = null
  cpu_max    = null
  memory_min = null
  memory_max = null
}
horizontal_pod_autoscaling = null
vertical_pod_autoscaling   = null
database_encryption_key    = ""
private_cluster_config = {
  enable_private_nodes    = null
  enable_private_endpoint = null
  master_ipv4_cidr_block  = "" //The IP range in CIDR notation to use for the hosted master network
  master_global_access    = null
}
master_authorized_ranges    = {}
enable_binary_authorization = null


