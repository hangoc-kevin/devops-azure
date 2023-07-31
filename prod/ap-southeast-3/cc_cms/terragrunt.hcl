include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = "${dirname(find_in_parent_folders())}/common/cc_cms.hcl"
}

inputs = {
  aks_task_memory                        = 512
  aks_container_registry                 = "abc.com.vn"
	aks_service_count                      = 2
  aks_service_scaling_min                = 2
  aks_service_scaling_max                = 2
  aks_service_scaling_scale_in_cooldown  = 300
  aks_service_scaling_scale_out_cooldown = 120
  aks_service_scaling_metric_target      = 70

  aks_service_scaling_scale_in_disabled = false
}
