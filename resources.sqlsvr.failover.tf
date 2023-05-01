
#---------------------------------------------------------
# Azure SQL Failover Group - Default is "false" 
#---------------------------------------------------------

resource "azurerm_sql_failover_group" "fog" {
  count               = var.enable_failover_group ? 1 : 0
  name                = "sqldb-failover-group"
  resource_group_name = local.resource_group_name
  server_name         = azurerm_mssql_server.primary_sql.name
  databases           = [azurerm_sql_database.single_database.id]
  tags                = merge({ "Name" = format("%s", "sqldb-failover-group") }, var.tags, )

  partner_servers {
    id = azurerm_mssql_server.secondary_sql.0.id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 60
  }

  readonly_endpoint_failover_policy {
    mode = "Enabled"
  }
}