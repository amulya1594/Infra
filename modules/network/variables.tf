variable "location" {
 
description = "Location where to deploy resources"
 
}
 
variable "rg_network" {
 
description = "Name of the Resource Group where resources will be deployed"
 
}

variable "vnet_address_space" { 

type = list

description = "Address space for Virtual Network"

default = ["10.0.0.0/16"]

}

variable "vnet_name" {
 
description = "Name of the vnet"
 
}

variable "subnet_name" {
 
description = "Name of the subnet"
 
}