// Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = "pip"
  location            = "westus2"
  resource_group_name = "vmpacker"
  allocation_method   = "Static"
  sku = "Standard"
}  

# Create network security group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg"
  location            = "westus2"
  resource_group_name = "vmpacker"

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

resource "azurerm_virtual_network" "trialvnet" {
  name                = "packervnet"
  address_space       = ["10.0.0.0/16"]
  location            = "westus2"
  resource_group_name = "vmpacker"
}


resource "azurerm_subnet" "trialsubnet" {
  name                 = "packersubnet"
  resource_group_name  = "vmpacker"
  virtual_network_name = azurerm_virtual_network.trialvnet.name
  address_prefix       = "10.0.2.0/24"
}


resource "azurerm_network_interface" "trialnic" {
  name                = "packernic"
  location            = "westus2"
  resource_group_name  = "vmpacker"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.trialsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

/* resource "azurerm_image" "image" {
  name = "myPackerWinImage"
  location = "westus2"
  resource_group_name = "vmpacker"
  os_disk {
     os_type ="Windows"
     os_state = "Generalized"
     caching = "ReadWrite"
  }
} */

data "azurerm_resource_group" "image" {
  name = "vmpacker"
}

data "azurerm_image" "image" {
  name                = "myPackerWinImage"
  resource_group_name = data.azurerm_resource_group.image.name
} 



resource "azurerm_windows_virtual_machine" "vm" {
  name                = "vm"
  location            = "westus2"
  resource_group_name = "vmpacker"
  size                = "${var.vm_size}"
  admin_username      = "${var.admin_username}"
  admin_password      = "${var.admin_password}"
  network_interface_ids = [
    azurerm_network_interface.trialnic.id,
  ]

  source_image_id = data.azurerm_image.image.id

  os_disk {
    name                 = "OS"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

 /*  source_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  } */

 resource "azurerm_network_interface_security_group_association" "nicassigntonsg" {
  network_interface_id      = azurerm_network_interface.trialnic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  //network_security_group_id = "${var.network_security_group_id}"
} 
  
}
