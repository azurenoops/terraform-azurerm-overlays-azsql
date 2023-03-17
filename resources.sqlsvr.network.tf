
resource "azurerm_mssql_virtual_network_rule" "vnet_rule_primary" {
  for_each  = try({ for subnet in local.primary_allowed_subnets : subnet.name => subnet }, {})
  name      = each.key
  server_id = azurerm_mssql_server.primary_sql.id
  subnet_id = each.value.subnet_id
}

resource "azurerm_mssql_virtual_network_rule" "vnet_rule_secondary" {
  for_each  = try({ for subnet in local.secondary_allowed_subnets : subnet.name => subnet }, {})
  name      = each.key
  server_id = azurerm_mssql_server.secondary_sql.id
  subnet_id = each.value.subnet_id
}
