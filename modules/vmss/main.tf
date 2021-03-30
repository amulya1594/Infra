resource "azurerm_windows_virtual_machine_scale_set" "example" {
  name                = "example-vmss"
  resource_group_name = "${var.rg_network}"
  location            = "${var.location}"
  sku                 = "${var.vm_size}"
  instances           =  1
  computer_name_prefix = "testvm"
  admin_password      = "${var.admin_password}"
  admin_username      = "${var.admin_username}"
  
  source_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = "${var.subnet_id}"
      load_balancer_backend_address_pool_ids = [var.load_balancer_backend_address_pool_ids] 
    }
  }
}
