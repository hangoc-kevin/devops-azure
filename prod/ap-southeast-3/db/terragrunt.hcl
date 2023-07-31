include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/common/db.hcl"
}

inputs = {
  app_services_db_instance_tier        = "GeneralPurpose"
  app_services_db_allocated_storage     = 20
  app_services_db_max_allocated_storage = 200
  app_services_db_apply_immediately     = false
  app_services_db_auto_shutdown         = false
  app_services_db_final_snapshot_skip   = false
  app_services_db_multi_az              = true
  app_services_db_deletion_protection   = true
  app_services_tag_aws_backup           = "4hours"
}
