include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/common/azure functions_logs_to_opensearch.hcl"
}

inputs = {}
