provider "azurerm" {
  subscription_id = ""
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""

  features {}
}
# crear usurio de app y darle permisos
# az ad sp create-for-rbac --name terraform
# az role assignment create --assignee 8a9c68c4-5478-4e02-b42e-a60c6e6e2573 --role "Resource Policy Contributor" --scope /subscriptions/8dcc0435-9f67-4310-9ca8-3cdc5fe6a09c
# az role assignment create --assignee 8a9c68c4-5478-4e02-b42e-a60c6e6e2573 --role "Contributor" --scope /subscriptions/8dcc0435-9f67-4310-9ca8-3cdc5fe6a09c
# az ad sp delete --id 8a9c68c4-5478-4e02-b42e-a60c6e6e2573

resource "azurerm_resource_group" "example" {
  name     = "myResourceGroup"
  location = "East US"
}

resource "azurerm_virtual_network" "example" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_public_ip" "example" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

resource "azurerm_subnet" "example" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "myNIC"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id # Asociar la dirección IP pública con la interfaz de red
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                  = "myVM"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  size                  = "Standard_DS1_v2"
  admin_username        = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("/home/carlos/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Para saber su ip piblica.
# az vm show -d --resource-group myResourceGroup --name myVM -o tsv --query publicIps
# ssh adminuser@52.179.9.6

# para que terraform no te pida el yes.
# terraform apply -auto-approve
# terraform destroy -auto-approve
