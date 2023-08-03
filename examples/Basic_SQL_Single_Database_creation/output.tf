output "primary_sql_server_id" {
  description = "The primary Microsoft SQL Server ID"
  value       = module.mod_mssql_single.primary_sql_server_id
}

output "primary_sql_server_fqdn" {
  description = "The fully qualified domain name of the primary Azure SQL Server"
  value       = module.mod_mssql_single.primary_sql_server_fqdn
}

output "secondary_sql_server_id" {
  description = "The secondary Microsoft SQL Server ID"
  value       = module.mod_mssql_single.secondary_sql_server_id
}

output "secondary_sql_server_fqdn" {
  description = "The fully qualified domain name of the secondary Azure SQL Server"
  value       = module.mod_mssql_single.secondary_sql_server_fqdn
}

output "sql_database_id" {
  description = "The SQL Database ID"
  value       = module.mod_mssql_single.sql_databases_id
}

output "sql_failover_group_id" {
  description = "A failover group of databases on a collection of Azure SQL servers."
  value       = module.mod_mssql_single.sql_failover_group_id
}