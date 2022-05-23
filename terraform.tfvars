project_id = "jk-network-project"
cluster = {
    name = "jk-cluster1"
    cluster_autoscaling = {
        cpu_min    = 1
        cpu_max    = 5
        memory_min = 1
        memory_max = 5
    }
    description = "JK Test cluster"
    dns_domain  = null
    labels      = {
        "clustertype": "testing"
    }
    location    = "us-central1"
    net = {
        master_range = "172.17.0.0/28"
        pods         = ""
        services     = ""
        subnet       = ""
    }
    overrides = null
}

network = "default"

