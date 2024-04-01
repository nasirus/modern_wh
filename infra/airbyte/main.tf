// Airbyte Terraform provider documentation: https://registry.terraform.io/providers/airbytehq/airbyte/latest/docs

// Sources
resource "airbyte_source_azure_blob_storage" "my_source_azureblobstorage" {
  configuration = {
    azure_blob_storage_account_key    = var.azure_blob_storage_account_key
    azure_blob_storage_account_name   = var.azure_blob_storage_account_name
    azure_blob_storage_container_name = var.azure_blob_storage_container_name
    streams = [
      {
        days_to_sync_if_history_is_full = 9
        format = {
          parquet_format = {
            decimal_as_float = false
          }
        }
        globs = [
          "*.parquet",
        ]
        name              = "btcusdt_klines_with_indicators"
        schemaless        = false
        validation_policy = "Emit Record"
      },
    ]
  }
  name          = "source_azure_storage_${var.azure_blob_storage_account_name}"
  workspace_id  = var.airbyte_workspace_id
}

resource "airbyte_destination_mssql" "my_destination_mssql" {
  configuration = {
    database        = "raw"
    host            = "localhost"
    password        = var.mssql_password
    port            = 1433
    schema          = "raw"
    ssl_method = {
      encrypted_trust_server_certificate = {}
    }
    tunnel_method = {
      no_tunnel = {}
    }
    username = "sa"
  }
  name          = "destination_mssql"
  workspace_id  = var.airbyte_workspace_id
}

resource "airbyte_connection" "my_connection" {
    configurations = {
        streams = [
            {
                cursor_field = [
                    "_ab_source_file_last_modified",
                ]
                name         = "btcusdt_klines_with_indicators"
                sync_mode    = "full_refresh_overwrite"
            },
        ]
    }
    source_id      = airbyte_source_azure_blob_storage.my_source_azureblobstorage.source_id
    destination_id = airbyte_destination_mssql.my_destination_mssql.destination_id
    data_residency                       = "auto"
    name                                 = "AzureBlobStorage_to_MSSQL"
    namespace_definition                 = "destination"
    non_breaking_schema_updates_behavior = "propagate_columns"
    schedule                             = {
        schedule_type = "manual"
    }
    status                               = "active"
}