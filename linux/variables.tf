variable "name" {}
variable "vm_size" {}

variable "admin_username" {
  default = "azureuser"
}

variable "cloud_config" {
  type = "string"
}

variable "location" {
  type = "string"
}

variable "resource_group_name" {
  type = "string"
}

variable "subnet_id" {
  type = "string"
}

variable "vm_offer" {
  type = "string"
  default = "CentOS"
}
variable "vm_publisher" {
  type = "string"
  default = "OpenLogic"
}
variable "vm_sku" {
  type = "string"
  default = "7.5"
}
variable "vm_version" {
  type = "string"
  default = "latest"
}

variable "storage_type" {}

variable "tags" {
  type = "map"
}

variable "ssh_key" {}

variable "ssh_port" {
  default = "22"
}
