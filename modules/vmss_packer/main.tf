/* resource "azurerm_virtual_network" "vmss" {
  name                = "vmss-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "westus2"
  resource_group_name = "vmpacker"

}
 
resource "azurerm_subnet" "vmss" {
  name                 = "vmss-subnet"
  resource_group_name  = "vmpacker"
  virtual_network_name = azurerm_virtual_network.vmss.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "vmss" {
  name                         = "vmss-public-ip"
  location                     = "westus2"
  resource_group_name          = "vmpacker"
  allocation_method            = "Static"
  
} */

data "azurerm_resource_group" "image" {
  name = "packer"
}

data "azurerm_image" "image" {
  name                = "myPackerWinImage"
  resource_group_name = data.azurerm_resource_group.image.name
}

resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "vmscaleset_packer"
  location            = "${var.location}"
  resource_group_name = "${var.rg_network}"
  upgrade_policy_mode = "Manual"
  //sku                 = "${var.vm_size}"


  sku {
    name     = "${var.vm_size}"
    //tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    id=data.azurerm_image.image.id
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

   storage_profile_data_disk {
    lun          = 0
    caching        = "ReadWrite"
    create_option  = "Empty"
    disk_size_gb   = 10
  }

  os_profile {
    computer_name_prefix = "vmlab"
    admin_username       = "${var.admin_username}"
    admin_password       = "${var.admin_password}"
  }

 network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "IPConfiguration"
      subnet_id                              = "${var.subnet_id}"
      primary = true
      load_balancer_backend_address_pool_ids = [var.load_balancer_backend_address_pool_ids] 
    }
  }
} 