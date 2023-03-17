# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------------
# Azure SQl Database Lock configuration - Default (required). 
#------------------------------------------------------------------
resource "azurerm_management_lock" "storage_account_level_lock" {
  count      = var.enable_resource_locks ? 1 : 0
  name       = "${local.server_name}-${var.lock_level}-lock"
  scope      = azurerm_mssql_server.sql.id
  lock_level = var.lock_level
  notes      = "Azure SQl Server '${local.server_name}' is locked with '${var.lock_level}' level."
}
