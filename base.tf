provider "azurerm" {}

variable "environment" {
  type = "string"
  default = "development"
}

variable "ssh_key" {
  type = "string"
}

variable "admin_username" {
  type    = "string"
  default = "azureuser"
}

variable "instance_prefix" {
  default = "paas"
}

variable "shared_prefix" {
  default = "demo"
}

variable "ssh_port" {
  default = "22"
}

variable "location" {
  default = "East US"
}

variable "standard_vm_size" {
  default = "Standard_B1s"
}

variable "storage_type" {
  default = "Standard_LRS"
}

variable "cloud_config" {
  default = "init.yml.tpl"
}

variable "cloud_runcmd" {
  default = "runcmd.yml.tpl"
}

locals {
  resource_group_name = "${var.shared_prefix}"

  tags = {
    environment = "${var.environment}"
    solution    = "${var.instance_prefix}"
  }

  vnet_name             = "${var.shared_prefix}"
  vnet_address_space    = "10.0.0.0/16"
  subnet_name           = "default"
  subnet_address_prefix = "10.0.0.0/24"
}

# Resource group
resource "azurerm_resource_group" "rg" {
  name      = "${local.resource_group_name}"
  location  = "${var.location}"
  tags      = "${merge(local.tags, map("provisionedBy", "terraform"))}"
}

# Networking
resource "azurerm_virtual_network" "vnet" {
  name                = "${local.vnet_name}"
  location            = "${azurerm_resource_group.rg.location}"
  address_space       = ["${local.vnet_address_space}"]
  resource_group_name = "${azurerm_resource_group.rg.name}"
  tags                = "${local.tags}"
}

resource "azurerm_subnet" "default" {
  name                  = "${local.subnet_name}"
  virtual_network_name  = "${azurerm_virtual_network.vnet.name}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  address_prefix        = "${local.subnet_address_prefix}"
}

data "template_file" "runcmd" {
  template = "${file("${path.module}/cloud-config/${var.cloud_runcmd}")}"
  vars {
    admin_username  = "${var.admin_username}"
  }
}

data "template_file" "cloud_config" {
  template = "${file("${path.module}/cloud-config/${var.cloud_config}")}"

  vars {
    ssh_port        = "${var.ssh_port}"
    ssh_key         = "${var.ssh_key}"
    admin_username  = "${var.admin_username}"
    runcmd          = "${data.template_file.runcmd.rendered}"
  }
}

module "linux" {
  source              = "./linux"
  name                = "${var.instance_prefix}"
  vm_size             = "${var.standard_vm_size}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  admin_username      = "${var.admin_username}"
  ssh_key             = "${var.ssh_key}"
  ssh_port            = "${var.ssh_port}"
  subnet_id           = "${azurerm_subnet.default.id}"
  storage_type        = "${var.storage_type}"
  tags                = "${local.tags}"
  cloud_config        = "${base64encode(data.template_file.cloud_config.rendered)}"
}
