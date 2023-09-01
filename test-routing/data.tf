# data "azurerm_management_group" "mg" {
#   name = "Primary"
# }

data "external" "current_ip" {
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}
