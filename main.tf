resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "adls" {
  name                     = "stetlcar12345"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  is_hns_enabled = true
}

resource "azurerm_storage_data_lake_gen2_filesystem" "raw" {
  name               = "raw"
  storage_account_id = azurerm_storage_account.adls.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "staging" {
  name               = "staging"
  storage_account_id = azurerm_storage_account.adls.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "curated" {
  name               = "curated"
  storage_account_id = azurerm_storage_account.adls.id
}

resource "azurerm_mssql_server" "sqlserver" {
  name                         = "sqlservercarlos12345"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin
  administrator_login_password = var.sql_password
}

resource "azurerm_mssql_database" "sqldb" {
  name      = "dbcardio"
  server_id = azurerm_mssql_server.sqlserver.id
}

resource "azurerm_data_factory" "adf" {
  name                = "adf-carlos-etl"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}