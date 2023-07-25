terraform {

  backend "azurerm" {
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# we can edit the subscription, tenantid, clientid and clientsecret
# we can edit the resource name, resource group name, location, sku, sql server credentilas and sql database credentials


provider "azurerm" {
  features {}
  skip_provider_registration = "true"
}


data "azurerm_resource_group"  "rg" {
  name                = "Opportunity-Tracker"
}

resource "azurerm_service_plan" "example" {
  name                = "example"
  resource_group_name = "Opportunity-Tracker"
  location            = "West US 2" 
  os_type             = "Windows"
  sku_name            = "Standard"
 
}

resource "azurerm_linux_web_app" "app" {
  name                = "example19072023"
  resource_group_name = "Opportunity-Tracker"
  location            = "West US 2"
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
    always_on = false
  }
}

depends_on = [
    azurerm_service_plan.example
]

resource "azurerm_sql_server" "example" {
  name                         = "myexamplesqlserver"
  resource_group_name          = "Opportunity-Tracker"
  location                     = "West US 2"
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"

}

resource "azurerm_mssql_database" "test" {
  name           = "acctest-db-d"
  server_id      = azurerm_mssql_server.example.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  sku_name       = "Standard"
  depends_on = [ 
    azurerm_mssql_server.example
   ]
 
}