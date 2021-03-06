resource "azurerm_network_interface" "maersk-2" {
  name                = "maersk-2-nic"
  location            = azurerm_resource_group.maersk.location
  resource_group_name = azurerm_resource_group.maersk.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.maersk-2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "maersk-2" {
  name                = "maersk-2-machine"
  resource_group_name = azurerm_resource_group.maersk.name
  location            = azurerm_resource_group.maersk.location
  size                = "Standa rd_F2"
  admin_username      = "adminuser"
  admin_password      = data.azurerm_key_vault_secret.admin-password.value
  network_interface_ids = [
    azurerm_network_interface.maersk-2.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
