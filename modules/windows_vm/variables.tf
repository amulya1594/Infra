variable "location" {
 
description = "Location where to deploy resources"
 
}
 
variable "rg_network" {
 
description = "Name of the Resource Group where resources will be deployed"
 
}
 
variable "servername" {
 
description = "Name of the server"
 
}
 
/* variable "subnet_id" {
 
description = "Subnet Id where to join the VM"
 
}

variable "backend_address_pool_id" {

description = "backendpool Id to join the lb and vnet"

}

variable "network_security_group_id" {

description = "network security group Id to join the vm and nsg"

} */
 
variable "vm_size" {
    type = string
    description = "Size of VM"
    default = "Standard_B2ms"
}

variable "admin_username" {
 
description = "The username associated with the local administrator account on the virtual machine"
 
}
 
variable "admin_password" {
 
description = "The password associated with the local administrator account on the virtual machine"
 
}
 

variable "os" {
    description = "OS image to deploy"
    type = object({
        publisher = string
        offer = string
        sku = string
        version = string
  })
}