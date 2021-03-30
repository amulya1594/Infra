
#Create windows vm with load balancer IP
/* 
 # Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = "pip-${var.location}"
  location            = "${var.location}"
  resource_group_name = "${var.rg_network}"
  allocation_method   = "Static"
  sku = "Standard"
}   */

/* # Create network security group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.location}"
  location            = "${var.location}"
  resource_group_name = "${var.rg_network}"

  security_rule {
    name                       = "rule1"
    priority                   =  100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
} */

# Create network interface
/* resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.location}"
  location            = "${var.location}"
  resource_group_name = "${var.rg_network}"

  ip_configuration {
    name                          = "nicip-${var.location}"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

#Create a virtual machine
resource "azurerm_windows_virtual_machine" "vm" {
  name                = "${var.servername}"
  location            = "${var.location}"
  resource_group_name = "${var.rg_network}"
  size                = "${var.vm_size}"
  admin_username      = "${var.admin_username}"
  admin_password      = "${var.admin_password}"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    name                 = "${var.servername}-OS"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  }
}

/* resource "azurerm_network_interface_security_group_association" "nicassigntonsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  //network_security_group_id = azurerm_network_security_group.nsg.id
  network_security_group_id = "${var.network_security_group_id}"
} */

/* resource "azurerm_network_interface_backend_address_pool_association" "nicbepoolass" {
    network_interface_id         = azurerm_network_interface.nic.id
    ip_configuration_name        = "nicip-${var.location}"
    backend_address_pool_id      = "${var.backend_address_pool_id}"
} 
 */



################################################3

# Create Windows VM with public IP

resource "azurerm_public_ip" "publicip" {
  name                = "pip"
  location            = "${var.location}"
  resource_group_name = "${var.rg_network}"
  allocation_method   = "Static"
  sku = "Standard"
} 

 resource "azurerm_virtual_network" "vnet" {
  name                = "winvnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${var.rg_network}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "winsub"
  resource_group_name  = "${var.rg_network}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg"
  location            = "${var.location}"
  resource_group_name = "${var.rg_network}"

  security_rule {
    name                       = "rule1"
    priority                   =  100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
} 

resource "azurerm_network_interface" "nic" {
  name                = "nic"
  location            = "${var.location}"
  resource_group_name = "${var.rg_network}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = "winvm"
  resource_group_name = "${var.rg_network}"
  location            = "${var.location}"
  size                = "${var.vm_size}"
  admin_username      = "${var.admin_username}"
  admin_password      = "${var.admin_password}"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  }
} 

 resource "azurerm_network_interface_security_group_association" "nicassigntonsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  
} 