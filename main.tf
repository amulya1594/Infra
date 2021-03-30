provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=2.42.0"
  features {}
}

 // Create Resource Group
 
resource "azurerm_resource_group" "rg_network" {
 
name = "${var.rg_network}"
 
location = "${var.location}"
 
}  
 
// Create Network


module "create_network" {
 
source = "./modules/network"
 
location = "${var.location}"
 
rg_network = "${var.rg_network}"

vnet_name = "${var.vnet_name}"

subnet_name = "${var.subnet_name}"
 
}      

//Create Load balancer
 
  
module "create_loadbalancer" {
 
source = "./modules/loadbalancer"
 
location = "${var.location}"
 
rg_network = "${var.rg_network}"
 
}  
 
 
 #Create vmss
/* 
module "create_vmss" {
 
source = "./modules/vmss"

location = "${var.location}"
 
rg_network = "${var.rg_network}"

subnet_id = "${module.create_network.subnet_id}"

load_balancer_backend_address_pool_ids = "${module.create_loadbalancer.load_balancer_backend_address_pool_ids}"

admin_username = "${var.admin_username}"

admin_password = "${var.admin_password}"

os = "${var.os}"

}   

 */
// Create Windows VM
/*   
module "windows_vm" {
 
source = "./modules/windows_vm"

location = "${var.location}"
 
rg_network = "${var.rg_network}"

servername = "${var.servername}"

//subnet_id = "${module.create_network.subnet_id}"

//network_security_group_id = "${module.create_network.network_security_group_id}"

//backend_address_pool_id = "${module.create_loadbalancer.backend_address_pool_id}"

admin_username = "${var.admin_username}"

admin_password = "${var.admin_password}"

os = "${var.os}"

} 
   */

#Create vmss_packer
    
module "create_vmss_packer" {
 
source = "./modules/vmss_packer"

location = "${var.location}"
 
rg_network = "${var.rg_network}"

subnet_id = "${module.create_network.subnet_id}"

load_balancer_backend_address_pool_ids = "${module.create_loadbalancer.load_balancer_backend_address_pool_ids}"

admin_username = "${var.admin_username}"

admin_password = "${var.admin_password}"

} 
 
 













