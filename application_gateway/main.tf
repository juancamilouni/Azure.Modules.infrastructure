##########################################
# Public IP (creada automáticamente)
##########################################
resource "azurerm_public_ip" "this" {
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"

  tags = var.tags
}

##########################################
# Application Gateway
##########################################
resource "azurerm_application_gateway" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = var.capacity
    max_capacity = 3
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  frontend_port {
    name = "http-port"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.this.id
  }

  ##########################################
  # Listeners
  ##########################################
  http_listener {
    name                           = "listener-web"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "http-port"
    host_name                      = var.web_domain
    protocol                       = "Http"
  }

  http_listener {
    name                           = "listener-api"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "http-port"
    host_name                      = var.api_domain
    protocol                       = "Http"
  }

  ##########################################
  # Certificado SSL (opcional)
  ##########################################
  dynamic "ssl_certificate" {
    for_each = var.ssl_cert != null ? [1] : []
    content {
      name     = "ssl-cert"
      data     = var.ssl_cert.data
      password = var.ssl_cert.password
    }
  }

  ##########################################
  # Backends
  ##########################################
  backend_address_pool {
    name  = "backend-web"
    fqdns = [var.swa_fqdn]
  }

  backend_address_pool {
    name  = "backend-api"
    fqdns = [var.apim_fqdn]
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Http"
    request_timeout       = 60
  }

  ##########################################
  # Rules
  ##########################################
  request_routing_rule {
    name                       = "rule-web"
    rule_type                  = "Basic"
    http_listener_name         = "listener-web"
    backend_address_pool_name  = "backend-web"
    backend_http_settings_name = "http-settings"
  }

  request_routing_rule {
    name                       = "rule-api"
    rule_type                  = "Basic"
    http_listener_name         = "listener-api"
    backend_address_pool_name  = "backend-api"
    backend_http_settings_name = "http-settings"
  }

  tags = var.tags
}
