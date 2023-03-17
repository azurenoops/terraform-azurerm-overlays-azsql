# Azure Sql Overlay Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurenoops/overlays-container-registry/azurerm/)

This Overlay terraform module can create a an [Azure SQL Server](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-servers)
and associated databases in an optional [SQL Elastic Pool](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-elastic-pool)
with [DTU purchasing model](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-service-tiers-dtu) or [vCore purchasing model](https://docs.microsoft.com/en-us/azure/azure-sql/database/resource-limits-vcore-elastic-pools)
only along with [Firewall rules](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-firewall-configure)
and manage related parameters (Private Endpoints, etc.) to be used in a [SCCA compliant Network](https://registry.terraform.io/modules/azurenoops/overlays-hubspoke/azurerm/latest).

## SCCA Compliance

This module can be SCCA compliant and can be used in a SCCA compliant Network. Enable private endpoints and SCCA compliant network rules to make it SCCA compliant.

For more information, please read the [SCCA documentation]("https://www.cisa.gov/secure-cloud-computing-architecture").

## Contributing

If you want to contribute to this repository, feel free to to contribute to our Terraform module.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Resources Used

* [Azure SQL Server](https://www.terraform.io/docs/providers/azurerm/r/sql_server.html)
* [Azure SQL Database](https://www.terraform.io/docs/providers/azurerm/r/sql_database.html)
* [Azure SQL Elastic Pool](https://www.terraform.io/docs/providers/azurerm/r/sql_elasticpool.html)
* [Azure SQL Firewall Rule](https://www.terraform.io/docs/providers/azurerm/r/sql_firewall_rule.html)
* [Private Endpoints](https://www.terraform.io/docs/providers/azurerm/r/private_endpoint.html)
* [Private DNS zone for `privatelink` A records](https://www.terraform.io/docs/providers/azurerm/r/private_dns_zone.html)
* [Azure Resource Locks](https://www.terraform.io/docs/providers/azurerm/r/management_lock.html)

## Limitations

* none

## Overlay Module Usage for basic sql server

```terraform
# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

#---------------------------------------------------------
# Azure Region Lookup
#----------------------------------------------------------
module "mod_azure_region_lookup" {
  source  = "azurenoops/overlays-azregions-lookup/azurerm"
  version = "~> 1.0.0"

  azure_region = "eastus"
}


module "acr" {
  depends_on = [
    azurerm_virtual_network.vnet
  ]
  source  = ""azurenoops/overlays-container-registry/azurerm"
  version = "x.x.x"

  # By default, this module will not create a resource group. If you wish 
  # to use an existing resource group, provide the name of the existing resource group.
  # using `existing_resource_group_name` will ignore `create_container_registry_resource_group` and `custom_resource_group_name`.
  # The location of the group  will remain the same if you use the current resource.
  create_container_registry_resource_group = true
  location                                 = module.mod_azure_region_lookup.location_cli
  environment                              = "public"
  deploy_environment                       = "dev"
  org_name                                 = "anoa"
  workload_name                            = "dev-acr"
  sku                                      = "Standard"

  # Tags for Azure Resources
  add_tags = {
    example = "basic_container_registry"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azurenoopsutils"></a> [azurenoopsutils](#requirement\_azurenoopsutils) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.22 |
| <a name="requirement_mssql"></a> [mssql](#requirement\_mssql) | >= 0.2.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurenoopsutils"></a> [azurenoopsutils](#provider\_azurenoopsutils) | ~> 1.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.22 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_custom_users"></a> [custom\_users](#module\_custom\_users) | ./modules/sql_db_users | n/a |
| <a name="module_databases_users"></a> [databases\_users](#module\_databases\_users) | ./modules/sql_db_users | n/a |
| <a name="module_mod_azure_region_lookup"></a> [mod\_azure\_region\_lookup](#module\_mod\_azure\_region\_lookup) | azurenoops/overlays-azregions-lookup/azurerm | ~> 1.0.0 |
| <a name="module_mod_sql_rg"></a> [mod\_sql\_rg](#module\_mod\_sql\_rg) | azurenoops/overlays-resource-group/azurerm | ~> 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_management_lock.storage_account_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_mssql_database.elastic_pool_database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_database.single_database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_database_extended_auditing_policy.elastic_pool_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database_extended_auditing_policy) | resource |
| [azurerm_mssql_database_extended_auditing_policy.single_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database_extended_auditing_policy) | resource |
| [azurerm_mssql_elasticpool.elastic_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_elasticpool) | resource |
| [azurerm_mssql_firewall_rule.firewall_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule) | resource |
| [azurerm_mssql_server.sql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_mssql_server_extended_auditing_policy.sql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_extended_auditing_policy) | resource |
| [azurerm_mssql_server_security_alert_policy.sql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_security_alert_policy) | resource |
| [azurerm_mssql_server_vulnerability_assessment.sql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_vulnerability_assessment) | resource |
| [azurerm_mssql_virtual_network_rule.vnet_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_virtual_network_rule) | resource |
| [azurerm_private_dns_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.vnet_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.pep](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_subnet.snet_pep](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurenoopsutils_resource_name.sql](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.sql_dbs](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.sql_pool](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurerm_resource_group.rgrp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.existing_snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_tags"></a> [add\_tags](#input\_add\_tags) | Map of custom tags. | `map(string)` | `{}` | no |
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | Administrator login for SQL Server | `string` | n/a | yes |
| <a name="input_administrator_password"></a> [administrator\_password](#input\_administrator\_password) | Administrator password for SQL Server | `string` | n/a | yes |
| <a name="input_alerting_email_addresses"></a> [alerting\_email\_addresses](#input\_alerting\_email\_addresses) | List of email addresses to send reports for threat detection and vulnerability assesment | `list(string)` | `[]` | no |
| <a name="input_allowed_cidr_list"></a> [allowed\_cidr\_list](#input\_allowed\_cidr\_list) | Allowed IP addresses to access the server in CIDR format. Default to all Azure services | `list(string)` | <pre>[<br>  "0.0.0.0/32"<br>]</pre> | no |
| <a name="input_allowed_subnets_ids"></a> [allowed\_subnets\_ids](#input\_allowed\_subnets\_ids) | List of Subnet ID to allow to connect to the SQL Instance | `list(string)` | `[]` | no |
| <a name="input_azuread_administrator"></a> [azuread\_administrator](#input\_azuread\_administrator) | Azure AD Administrator configuration block of this SQL Server. | <pre>object({<br>    login_username              = optional(string)<br>    object_id                   = optional(string)<br>    tenant_id                   = optional(string)<br>    azuread_authentication_only = optional(bool)<br>  })</pre> | `null` | no |
| <a name="input_backup_retention"></a> [backup\_retention](#input\_backup\_retention) | Definition of long term backup retention for all the databases in this SQL Server. | <pre>object({<br>    weekly_retention  = optional(number)<br>    monthly_retention = optional(number)<br>    yearly_retention  = optional(number)<br>    week_of_year      = optional(number)<br>  })</pre> | `{}` | no |
| <a name="input_connection_policy"></a> [connection\_policy](#input\_connection\_policy) | The connection policy the server will use. Possible values are `Default`, `Proxy`, and `Redirect` | `string` | `"Default"` | no |
| <a name="input_create_databases_users"></a> [create\_databases\_users](#input\_create\_databases\_users) | True to create a user named <db>\_user on each database with generated password and role db\_owner. | `bool` | `true` | no |
| <a name="input_create_private_endpoint_subnet"></a> [create\_private\_endpoint\_subnet](#input\_create\_private\_endpoint\_subnet) | Controls if the subnet should be created. If set to false, the subnet name must be provided. Default is false. | `bool` | `false` | no |
| <a name="input_create_sql_resource_group"></a> [create\_sql\_resource\_group](#input\_create\_sql\_resource\_group) | Controls if the resource group should be created. If set to false, the resource group name must be provided. Default is false. | `bool` | `false` | no |
| <a name="input_custom_resource_group_name"></a> [custom\_resource\_group\_name](#input\_custom\_resource\_group\_name) | The name of the custom resource group to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_custom_users"></a> [custom\_users](#input\_custom\_users) | List of objects for custom users creation. <br>    Password are generated.<br>    These users are created within the "custom\_users" submodule. | <pre>list(object({<br>    name     = string<br>    database = string<br>    roles    = optional(list(string))<br>  }))</pre> | `[]` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | List of the databases configurations for this server. | <pre>list(object({<br>    name                        = string<br>    license_type                = optional(string)<br>    max_size_gb                 = number<br>    create_mode                 = optional(string)<br>    min_capacity                = optional(number)<br>    auto_pause_delay_in_minutes = optional(number)<br>    read_scale                  = optional(string)<br>    read_replica_count          = optional(number)<br>    creation_source_database_id = optional(string)<br>    restore_point_in_time       = optional(string)<br>    recover_database_id         = optional(string)<br>    restore_dropped_database_id = optional(string)<br>    storage_account_type        = optional(string, "Geo")<br>    database_add_tags         = optional(map(string), {})<br>  }))</pre> | `[]` | no |
| <a name="input_databases_collation"></a> [databases\_collation](#input\_databases\_collation) | SQL Collation for the databases | `string` | `"SQL_LATIN1_GENERAL_CP1_CI_AS"` | no |
| <a name="input_databases_extended_auditing_enabled"></a> [databases\_extended\_auditing\_enabled](#input\_databases\_extended\_auditing\_enabled) | True to enable extended auditing for SQL databases | `bool` | `false` | no |
| <a name="input_databases_extended_auditing_retention_days"></a> [databases\_extended\_auditing\_retention\_days](#input\_databases\_extended\_auditing\_retention\_days) | Databases extended auditing logs retention | `number` | `30` | no |
| <a name="input_databases_zone_redundant"></a> [databases\_zone\_redundant](#input\_databases\_zone\_redundant) | True to have databases zone redundant, which means the replicas of the databases will be spread across multiple availability zones. This property is only settable for `Premium` and `Business Critical` databases. | `bool` | `null` | no |
| <a name="input_default_tags_enabled"></a> [default\_tags\_enabled](#input\_default\_tags\_enabled) | Option to enable or disable default tags. | `bool` | `true` | no |
| <a name="input_deploy_environment"></a> [deploy\_environment](#input\_deploy\_environment) | The environment to deploy. It defaults to dev. | `string` | `"dev"` | no |
| <a name="input_elastic_pool_add_tags"></a> [elastic\_pool\_add\_tags](#input\_elastic\_pool\_add\_tags) | Extra tags to add on ElasticPool | `map(string)` | `{}` | no |
| <a name="input_elastic_pool_custom_name"></a> [elastic\_pool\_custom\_name](#input\_elastic\_pool\_custom\_name) | Name of the SQL Elastic Pool, generated if not set. | `string` | `""` | no |
| <a name="input_elastic_pool_databases_max_capacity"></a> [elastic\_pool\_databases\_max\_capacity](#input\_elastic\_pool\_databases\_max\_capacity) | The maximum capacity (DTU or vCore) any one database can consume in the Elastic Pool. Default to the max Elastic Pool capacity. | `number` | `null` | no |
| <a name="input_elastic_pool_databases_min_capacity"></a> [elastic\_pool\_databases\_min\_capacity](#input\_elastic\_pool\_databases\_min\_capacity) | The minimum capacity (DTU or vCore) all databases are guaranteed in the Elastic Pool. Defaults to 0. | `number` | `0` | no |
| <a name="input_enable_elastic_pool"></a> [elastic\_pool\_enabled](#input\_elastic\_pool\_enabled) | True to deploy the databases in an ElasticPool, single databases are deployed otherwise. | `bool` | `false` | no |
| <a name="input_elastic_pool_license_type"></a> [elastic\_pool\_license\_type](#input\_elastic\_pool\_license\_type) | Specifies the license type applied to this database. Possible values are `LicenseIncluded` and `BasePrice` | `string` | `null` | no |
| <a name="input_elastic_pool_max_size"></a> [elastic\_pool\_max\_size](#input\_elastic\_pool\_max\_size) | Maximum size of the Elastic Pool in gigabytes | `string` | `null` | no |
| <a name="input_elastic_pool_sku"></a> [elastic\_pool\_sku](#input\_elastic\_pool\_sku) | SKU for the Elastic Pool with tier and eDTUs capacity. Premium tier with zone redundancy is mandatory for high availability.<br>    Possible values for tier are `GeneralPurpose`, `BusinessCritical` for vCore models and `Basic`, `Standard`, or `Premium` for DTU based models.<br>    See https://docs.microsoft.com/en-us/azure/sql-database/sql-database-dtu-resource-limits-elastic-pools" | <pre>object({<br>    tier     = string,<br>    capacity = number,<br>  })</pre> | `null` | no |
| <a name="input_elastic_pool_zone_redundant"></a> [elastic\_pool\_zone\_redundant](#input\_elastic\_pool\_zone\_redundant) | True to have the Elastic Pool zone redundant, SKU tier must be Premium to use it. This is mandatory for high availability. | `bool` | `false` | no |
| <a name="input_enable_private_endpoint"></a> [enable\_private\_endpoint](#input\_enable\_private\_endpoint) | Manages a Private Endpoint to Azure Container Registry. Default is false. | `bool` | `false` | no |
| <a name="input_enable_resource_locks"></a> [enable\_resource\_locks](#input\_enable\_resource\_locks) | (Optional) Enable resource locks | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The Terraform backend environment e.g. public or usgovernment | `string` | `null` | no |
| <a name="input_existing_private_dns_zone"></a> [existing\_private\_dns\_zone](#input\_existing\_private\_dns\_zone) | Name of the existing private DNS zone | `any` | `null` | no |
| <a name="input_existing_private_subnet_name"></a> [existing\_private\_subnet\_name](#input\_existing\_private\_subnet\_name) | Name of the existing subnet for the private endpoint | `any` | `null` | no |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | The name of the existing resource group to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table' | `string` | n/a | yes |
| <a name="input_lock_level"></a> [lock\_level](#input\_lock\_level) | (Optional) id locks are enabled, Specifies the Level to be used for this Lock. | `string` | `"CanNotDelete"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Optional prefix for the generated name | `string` | `""` | no |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | Optional suffix for the generated name | `string` | `""` | no |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | A name for the organization. It defaults to anoa. | `string` | `"anoa"` | no |
| <a name="input_outbound_network_restriction_enabled"></a> [outbound\_network\_restriction\_enabled](#input\_outbound\_network\_restriction\_enabled) | Whether outbound network traffic is restricted for this server | `bool` | `false` | no |
| <a name="input_point_in_time_restore_retention_days"></a> [point\_in\_time\_restore\_retention\_days](#input\_point\_in\_time\_restore\_retention\_days) | Point In Time Restore configuration. Value has to be between `7` and `35` | `number` | `7` | no |
| <a name="input_private_subnet_address_prefix"></a> [private\_subnet\_address\_prefix](#input\_private\_subnet\_address\_prefix) | The name of the subnet for private endpoints | `any` | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | True to allow public network access for this server | `bool` | `false` | no |
| <a name="input_security_storage_account_access_key"></a> [security\_storage\_account\_access\_key](#input\_security\_storage\_account\_access\_key) | Storage Account access key used to store security logs and reports | `string` | `null` | no |
| <a name="input_security_storage_account_blob_endpoint"></a> [security\_storage\_account\_blob\_endpoint](#input\_security\_storage\_account\_blob\_endpoint) | Storage Account blob endpoint used to store security logs and reports | `string` | `null` | no |
| <a name="input_security_storage_account_container_name"></a> [security\_storage\_account\_container\_name](#input\_security\_storage\_account\_container\_name) | Storage Account container name where to store SQL Server vulneralibility assessment | `string` | `null` | no |
| <a name="input_server_add_tags"></a> [server\_add\_tags](#input\_server\_add\_tags) | Extra tags to add on SQL Server or ElasticPool | `map(string)` | `{}` | no |
| <a name="input_server_custom_name"></a> [server\_custom\_name](#input\_server\_custom\_name) | Name of the SQL Server, generated if not set. | `string` | `""` | no |
| <a name="input_server_version"></a> [server\_version](#input\_server\_version) | Version of the SQL Server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). See https://www.terraform.io/docs/providers/azurerm/r/sql_server.html#version | `string` | `"12.0"` | no |
| <a name="input_single_databases_sku_name"></a> [single\_databases\_sku\_name](#input\_single\_databases\_sku\_name) | Specifies the name of the SKU used by the database. For example, `GP_S_Gen5_2`, `HS_Gen4_1`, `BC_Gen5_2`. Use only if `enable_elastic_pool` variable is set to `false`. More documentation [here](https://docs.microsoft.com/en-us/azure/azure-sql/database/service-tiers-general-purpose-business-critical) | `string` | `"GP_Gen5_2"` | no |
| <a name="input_sql_server_extended_auditing_enabled"></a> [sql\_server\_extended\_auditing\_enabled](#input\_sql\_server\_extended\_auditing\_enabled) | True to enable extended auditing for SQL Server | `bool` | `false` | no |
| <a name="input_sql_server_extended_auditing_retention_days"></a> [sql\_server\_extended\_auditing\_retention\_days](#input\_sql\_server\_extended\_auditing\_retention\_days) | Server extended auditing logs retention | `number` | `30` | no |
| <a name="input_sql_server_security_alerting_enabled"></a> [sql\_server\_security\_alerting\_enabled](#input\_sql\_server\_security\_alerting\_enabled) | True to enable security alerting for this SQL Server | `bool` | `false` | no |
| <a name="input_sql_server_vulnerability_assessment_enabled"></a> [sql\_server\_vulnerability\_assessment\_enabled](#input\_sql\_server\_vulnerability\_assessment\_enabled) | True to enable vulnerability assessment for this SQL Server | `bool` | `false` | no |
| <a name="input_threat_detection_policy_disabled_alerts"></a> [threat\_detection\_policy\_disabled\_alerts](#input\_threat\_detection\_policy\_disabled\_alerts) | Specifies a list of alerts which should be disabled. Possible values include `Access_Anomaly`, `Sql_Injection` and `Sql_Injection_Vulnerability` | `list(string)` | `[]` | no |
| <a name="input_enable_threat_detection_policy"></a> [threat\_detection\_policy\_enabled](#input\_threat\_detection\_policy\_enabled) | True to enable thread detection policy on the databases | `bool` | `false` | no |
| <a name="input_threat_detection_policy_retention_days"></a> [threat\_detection\_policy\_retention\_days](#input\_threat\_detection\_policy\_retention\_days) | Specifies the number of days to keep in the Threat Detection audit logs | `number` | `7` | no |
| <a name="input_tls_minimum_version"></a> [tls\_minimum\_version](#input\_tls\_minimum\_version) | The TLS minimum version for all SQL Database associated with the server. Valid values are: `1.0`, `1.1` and `1.2`. | `string` | `"1.2"` | no |
| <a name="input_use_location_short_name"></a> [use\_location\_short\_name](#input\_use\_location\_short\_name) | Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored. | `bool` | `true` | no |
| <a name="input_use_naming"></a> [use\_naming](#input\_use\_naming) | Use the Azure NoOps naming provider to generate default resource name. `custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| <a name="input_use_naming_for_databases"></a> [use\_naming\_for\_databases](#input\_use\_naming\_for\_databases) | Use the Azure NoOps naming provider to generate databases names. | `bool` | `false` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the virtual network for the private endpoint | `any` | `null` | no |
| <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name) | A name for the workload. It defaults to acr. | `string` | `"acr"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_databases_users"></a> [custom\_databases\_users](#output\_custom\_databases\_users) | Map of the custom SQL Databases users |
| <a name="output_custom_databases_users_roles"></a> [custom\_databases\_users\_roles](#output\_custom\_databases\_users\_roles) | Map of the custom SQL Databases users roles |
| <a name="output_default_administrator_databases_connection_strings"></a> [default\_administrator\_databases\_connection\_strings](#output\_default\_administrator\_databases\_connection\_strings) | Map of the SQL Databases with administrator credentials connection strings |
| <a name="output_default_databases_users"></a> [default\_databases\_users](#output\_default\_databases\_users) | Map of the SQL Databases dedicated users |
| <a name="output_identity"></a> [identity](#output\_identity) | Identity block with principal ID and tenant ID used for this SQL Server |
| <a name="output_security_alert_policy_id"></a> [security\_alert\_policy\_id](#output\_security\_alert\_policy\_id) | ID of the MS SQL Server Security Alert Policy |
| <a name="output_sql_administrator_login"></a> [sql\_administrator\_login](#output\_sql\_administrator\_login) | SQL Administrator login |
| <a name="output_sql_administrator_password"></a> [sql\_administrator\_password](#output\_sql\_administrator\_password) | SQL Administrator password |
| <a name="output_sql_databases"></a> [sql\_databases](#output\_sql\_databases) | SQL Databases |
| <a name="output_sql_databases_id"></a> [sql\_databases\_id](#output\_sql\_databases\_id) | Map of the SQL Databases IDs |
| <a name="output_sql_elastic_pool"></a> [sql\_elastic\_pool](#output\_sql\_elastic\_pool) | SQL Elastic Pool |
| <a name="output_sql_elastic_pool_id"></a> [sql\_elastic\_pool\_id](#output\_sql\_elastic\_pool\_id) | ID of the SQL Elastic Pool |
| <a name="output_sql_server"></a> [sql\_server](#output\_sql\_server) | SQL Server |
| <a name="output_vulnerability_assessment_id"></a> [vulnerability\_assessment\_id](#output\_vulnerability\_assessment\_id) | ID of the MS SQL Server Vulnerability Assessment |
<!-- END_TF_DOCS -->