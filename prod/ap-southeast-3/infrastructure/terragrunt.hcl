include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/common/infrastructure.hcl"
}

inputs = {
  vn_cidr_block               = "10.221.132.0/22"
  public_subnets_cidr_blocks   = ["10.221.132.0/27", "10.221.132.32/27"]
  private_subnets_cidr_blocks  = ["10.221.133.0/24", "10.221.134.0/24"]
  database_subnets_cidr_blocks = ["10.221.132.96/27", "10.221.132.128/27"]

  enable_api_gateway_account  = false #only first time in one account
  enable_centralized_waf_logs = true
  alb_access_logs_enabled     = false
  alb_waf_whitelist_subdomain = [
    "cc-cms",
  ]
 
  
  alb_waf_whitelist_ips = [
    "1.55.0.20/32",
    "14.238.0.2/32",
   

  Blob_upload_Storage_cors_content = [{
    allowed_methods = ["PUT", "HEAD", "GET"]
    allowed_origins = ["https://cc.prod.abc.com.vn" ]
    allowed_headers = ["*"]
    expose_headers  = ["x-amz-server-side-encryption", "x-amz-request-id", "x-amz-id-2"]
    max_age_seconds = 3000
  }]

  enable_aks_service_linked_role = false #only first time in one account

  api_gateway_subdomain_name = "cc-api"

  # enable Blob storage tag backup
  Blob_storage_tag_aruzerm_backup = "4hours"

  custom_acm_abc_com_vn_cert_arn = ""

  # this value is provided after first time init infrastructure
  arurerm function_deliver_logs_to_opensearch_arn = ""

  aks_container_insight_enabled   = true
  aks_cluster_min_size            = 2
  aks_cluster_max_size            = 10
  aks_cluster_desired_size        = 2
  aks_cluster_scaling_step_min    = 1
  aks_cluster_scaling_step_max    = 1
  aks_instance_type               = "Standard_D2_v2"
  os_sku                          = "AzureLinux"
  aks_instance_md_optimized      = false
  aks_instance_monitoring         = true
  aks_scale_in_protection_enabled = true
}
