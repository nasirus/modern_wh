variable "workspace_id" {
    type = string
}
variable "azure_blob_storage_account_key" {
  type = string
  sensitive = true
}
variable "azure_blob_storage_account_name" {
  type = string
  sensitive = false
}
variable "azure_blob_storage_container_name" {
  type = string
  sensitive = false
}
variable "mssql_password" {
  type = string
  sensitive = true
}