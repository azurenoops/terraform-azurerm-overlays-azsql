# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "databases_users" {
  for_each = try({ for user in local.databases_users : format("%s-%s", user.username, user.database) => user }, {})

  source = "./modules/sql_db_users"

  depends_on = [
    azurerm_mssql_database.single_database,
    azurerm_mssql_database.elastic_pool_database
  ]

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  sql_server_hostname = azurerm_mssql_server.sql.fully_qualified_domain_name

  database_name = each.value.database
  user_name     = each.key
  user_roles    = each.value.roles
}

module "custom_users" {
  for_each = try({ for custom_user in var.custom_users : format("%s-%s", custom_user.name, custom_user.database) => custom_user }, {})

  source = "./modules/sql_db_users"

  depends_on = [
    azurerm_mssql_database.single_database,
    azurerm_mssql_database.elastic_pool_database
  ]

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  sql_server_hostname = azurerm_mssql_server.sql.fully_qualified_domain_name

  database_name = var.elastic_pool_enabled ? azurerm_mssql_database.elastic_pool_database[each.value.database].name : azurerm_mssql_database.single_database[each.value.database].name
  user_name     = each.value.name
  user_roles    = each.value.roles
}

#-----------------------------------------------------------------------------------------------
# Adding AD Admin to SQL Server - Secondary server depend on Failover Group - Default is "false"
#-----------------------------------------------------------------------------------------------

resource "azurerm_sql_active_directory_administrator" "ad_user1" {
  count               = var.ad_admin_login_name != null ? 1 : 0
  server_name         = azurerm_sql_server.primary.name
  resource_group_name = local.resource_group_name
  login               = var.ad_admin_login_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
}

resource "azurerm_sql_active_directory_administrator" "ad_user2" {
  count               = var.enable_failover_group && var.ad_admin_login_name != null ? 1 : 0
  server_name         = azurerm_sql_server.secondary.0.name
  resource_group_name = local.resource_group_name
  login               = var.ad_admin_login_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
}
