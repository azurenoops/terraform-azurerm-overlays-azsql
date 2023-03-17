

resource "random_password" "admin_password" {
  special          = true
  override_special = "#$%&-_+{}<>:"
  upper            = true
  lower            = true
  number           = true
  length           = 32
}

# Single Database
module "sql_single" {
  source = "../.."
  #source  = "azurenoops/azsql/azurerm"
  #version = "x.x.x"

  # By default, this module will create a resource group and 
  # provide a name for an existing resource group. If you wish 
  # to use an existing resource group, change the option 
  # to "create_sql_resource_group = false." The location of the group 
  # will remain the same if you use the current resource.
  create_sql_resource_group = true
  location                  = module.mod_azure_region_lookup.location_cli
  environment               = "public"
  deploy_environment        = "dev"
  org_name                  = "anoa"
  workload_name             = "dev-acr"

  # The name of the SQL Server. If you do not provide a name,
  # the module will generate a name for you.
  administrator_login    = "adminsqltest"
  administrator_password = random_password.admin_password.result

  # Create a database users.
  create_databases_users = true

  elastic_pool_enabled = false

  # Create a database.
  databases = [
    {
      name        = "db1"
      max_size_gb = 50
    },
    {
      name        = "db2"
      max_size_gb = 180
    }
  ]

  # The custom users creates a user with the specified roles. 
  custom_users = [
    {
      database = "db1"
      name     = "db1_custom1"
      roles    = ["db_accessadmin", "db_securityadmin"]
    },
    {
      database = "db1"
      name     = "db1_custom2"
      roles    = ["db_accessadmin", "db_securityadmin"]
    },
    {
      database = "db2"
      name     = "db2_custom1"
      roles    = []
    },
    {
      database = "db2"
      name     = "db2_custom2"
      roles    = ["db_accessadmin", "db_securityadmin"]
    }
  ]
}
