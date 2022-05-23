# Gateway API module
This module can be used to activate Gateway API CRDs 0.4.3alpha1 v0.4.3alpha2 to a given gke cluster.

To use this module you must ensure the following APIs are enabled in the target project:
```
"container.googleapis.com"
"gkehub.googleapis.com"
"gkeconnect.googleapis.com"
"anthosconfigmanagement.googleapis.com"
"multiclusteringress.googleapis.com"
"multiclusterservicediscovery.googleapis.com"
"trafficdirector.googleapis.com"
```

## Usage example

```hcl
module "gke-gateway-api" {
  source         = "./modules/gateway-api"
  endpoint       = module.gke_1.endpoint
  ca_certificate = module.gke_1.ca_certificate
}
```