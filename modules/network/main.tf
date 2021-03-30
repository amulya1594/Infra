resource "azurerm_virtual_network" "vnet" {
 
name = "${var.vnet_name}"
 
location = "${var.location}"
 
resource_group_name = "${var.rg_network}"
 
address_space = "${var.vnet_address_space}"
 
}
 
resource "azurerm_subnet" "subnet" {
 
name = "${var.subnet_name}"
 
resource_group_name = "${var.rg_network}"
 
virtual_network_name = "${azurerm_virtual_network.vnet.name}"
 
address_prefix = "10.0.0.0/24"
 
}

resource "azurerm_network_security_group" "network_security_group" {

resource_group_name = "${var.rg_network}"

location = "${var.location}"

name = "nsg"

}

resource "azurerm_subnet_network_security_group_association" "nsg" {

subnet_id = azurerm_subnet.subnet.id

network_security_group_id = azurerm_network_security_group.network_security_group.id

}

resource "azurerm_network_security_rule" "nsgrule1" {

  name                        = "rule1"

  resource_group_name         = "${var.rg_network}"

  network_security_group_name = azurerm_network_security_group.network_security_group.name

  priority                    = 100

  direction                   = "Inbound"

  access                      = "Allow"

  protocol                    = "Tcp"

  source_port_range           = "*"

  destination_port_range      = "3389"

  source_address_prefix       = "*"

  destination_address_prefix  = "*"

}

resource "azurerm_network_security_rule" "nsgrule2" {

  name                        = "rule2"

  resource_group_name         = "${var.rg_network}"

  network_security_group_name = azurerm_network_security_group.network_security_group.name

  priority                    = 110

  direction                   = "Inbound"

  access                      = "Allow"

  protocol                    = "Tcp"

  source_port_range           = "*"

  destination_port_range      = "*"

  source_address_prefix       = "*"

  destination_address_prefix  = "*"

}
 
output "subnet_id" {
 
value = "${azurerm_subnet.subnet.id}"
 
}

output "network_security_group_id" {
 
value = "${azurerm_network_security_group.network_security_group.id}"
 
}