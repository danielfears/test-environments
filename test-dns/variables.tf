variable "prefix" {
  default = "onboardingresources"
}

variable "dns_records" {
  description = "Map of DNS record name and IPv4 Addresses"
  type        = map(string)
  default = {
    "splunk-deploy.tooling"         = "10.0.44.187"
    "splunk-deployment.tooling"     = "10.0.44.188"
    "splunk-forwarder.tooling"      = "10.0.44.187"
    "splunk-forwarder2.tooling"     = "10.0.44.187"
    "splunk-indexer-0.tooling"      = "10.0.44.190"
    "splunk-indexer-1.tooling"      = "10.0.44.192"
    "splunk-indexer-2.tooling"      = "10.0.44.193"
    "splunk-indexer.tooling"        = "10.0.44.194"
    "splunk-license.tooling"        = "10.0.44.187"
    "splunk-master.tooling"         = "10.0.44.187"
    "splunk-search-es.tooling"      = "10.0.44.187"
    "splunk-search-es-mgmt.tooling" = "10.0.44.195"
    "splunk-search.tooling"         = "10.0.44.187"
    "trend.tooling.dev"             = "10.64.41.4"
    "trend.tooling"                 = "10.0.41.4"
    "gitlab.tooling"                = "10.0.50.245"
    "netbox.tooling"                = "10.0.50.247"
  }
}
