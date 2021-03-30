variable "location" {

description = "Azure location of terraform env"

type        =  string

}

variable "rg_network" {

description = "Azure resource group of terraform env"

type        =  string

}

variable "vnet_name" {
 
description = "Name of the vnet"
 
}

variable "subnet_name" {
 
description = "Name of the subnet"
 
}


variable "vnet_address_space" { 

type = list

description = "Address space for Virtual Network"

default = ["10.0.0.0/16"]

}

variable "servername" {
 
description = "Name of the server"
 
}

variable "vm_size" {
    type = string
    description = "Size of VM"
    default = "Standard_B2ms"
}

variable "admin_username" {

default = "azureuser"

}

variable "admin_password" {

default = "password@12345"

}

variable "application_port" {
   description = "The port that you want to expose to the external load balancer"
   default     = 80
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
