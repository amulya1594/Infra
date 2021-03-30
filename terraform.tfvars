rg_network = "TerraformDemo"
location = "eastus2"
vnet_name = "Terraformvnet"
subnet_name = "Terraformsubnet"
vnet_address_space = ["10.0.0.0/16","10.1.0.0/16"]
servername = "terraformwinvm"
os = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
}