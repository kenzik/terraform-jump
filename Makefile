SSH_KEY := $(HOME)/.ssh/id_rsa.pub
ifneq (,$(wildcard $(SSH_KEY)))
	export TF_VAR_admin_username := $(USER)
	export TF_VAR_ssh_key := $(shell cat $(SSH_KEY))
endif

export TF_VAR_shared_prefix := "dkjump"
export TF_VAR_instance_prefix := "centos"
export TF_VAR_environment := "jump"
export TF_VAR_vm_publisher := "OpenLogic"
export TF_VAR_vm_offer := "CentOS"
export TF_VAR_vm_sku := "7.5"
export TF_VAR_environment := "jump"
export TF_VAR_standard_vm_size := "Standard_DS1_v2"
export TF_VAR_cloud_config := "init.yml.tpl"

.PHONY: plan apply destroy validate

plan destroy validate:
	terraform $@

apply:
	terraform $@
	terraform output --module=linux
