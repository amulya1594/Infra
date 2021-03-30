resource "azurerm_public_ip" "pubip" {
  name                = "pubipLB-${var.location}"
  location            = "${var.location}"
  resource_group_name = "${var.rg_network}"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "loadbalancer" {
  name                = "lb-${var.location}"
  location            = "${var.location}"
  resource_group_name = "${var.rg_network}"
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pubip.id
  }
} 

#Create load balancer backend pool for vm

resource "azurerm_lb_backend_address_pool" "backend_address_pool" {
  resource_group_name = "${var.rg_network}"
  loadbalancer_id     = azurerm_lb.loadbalancer.id
  name                = "vmlbbepool"
}

#Create load balancer backend pool for vmss

resource "azurerm_lb_backend_address_pool" "load_balancer_backend_address_pool" {
  resource_group_name = "${var.rg_network}"
  loadbalancer_id     = azurerm_lb.loadbalancer.id
  name                = "vmsslbbepool"
}

#Create load balancer health probe for vm

resource "azurerm_lb_probe" "lbvmprobe" {
  resource_group_name = "${var.rg_network}"
  loadbalancer_id     = azurerm_lb.loadbalancer.id
  name                = "lbvmprobe"
  port                = 80
}

#Create load balancer health probe for vmss

resource "azurerm_lb_probe" "lbvmssprobe" {
  resource_group_name = "${var.rg_network}"
  loadbalancer_id     = azurerm_lb.loadbalancer.id
  name                = "lbvmssprobe"
  port                = 3389
}

#Create load balancer rule for vm

/* resource "azurerm_lb_rule" "lb_vmports" {
  resource_group_name            = "${var.rg_network}"
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  name                           = "lbvmrule"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.lbvmprobe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.backend_address_pool.id
} */

#Create load balancer rule for vmss

resource "azurerm_lb_rule" "lb_vmssports" {
  resource_group_name            = "${var.rg_network}"
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  name                           = "lbvmssrule"
  protocol                       = "TCP"
  frontend_port                  = 13389
  backend_port                   = 3389
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.lbvmssprobe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.load_balancer_backend_address_pool.id
}

resource "azurerm_lb_rule" "lb_vmssportshttp" {
  resource_group_name            = "${var.rg_network}"
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  name                           = "lbvmssrulehttp"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.lbvmssprobe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.load_balancer_backend_address_pool.id
}

output "backend_address_pool_id" {
 
value = "${azurerm_lb_backend_address_pool.backend_address_pool.id}"
 
}

output "load_balancer_backend_address_pool_ids" {
 
value = "${azurerm_lb_backend_address_pool.load_balancer_backend_address_pool.id}"
 
}










