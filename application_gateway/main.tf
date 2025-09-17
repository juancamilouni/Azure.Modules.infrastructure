resource "azurerm_public_ip" "this" {
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_application_gateway" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = "WAF_Medium" # calidad-precio
    tier     = "WAF"
    capacity = var.capacity
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "https-port"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "public-frontend"
    public_ip_address_id = azurerm_public_ip.this.id
  }

  # Certificado cargado manualmente (PFX)
  # Si lo gestionas en portal, este bloque se ignora
  dynamic "ssl_certificate" {
    for_each = var.ssl_cert != null ? [1] : []
    content {
      name     = "cert-manual"
      data     = var.ssl_cert.data
      password = var.ssl_cert.password
    }
  }

  # Listener para Static WebApp
  http_listener {
    name                           = "listener-web"
    frontend_ip_configuration_name = "public-frontend"
    frontend_port_name             = "https-port"
    protocol                       = "Https"
    ssl_certificate_name           = var.ssl_cert != null ? "cert-manual" : null
    host_name                      = var.web_domain
  }

  # Listener para API Management
  http_listener {
    name                           = "listener-api"
    frontend_ip_configuration_name = "public-frontend"
    frontend_port_name             = "https-port"
    protocol                       = "Https"
    ssl_certificate_name           = var.ssl_cert != null ? "cert-manual" : null
    host_name                      = var.api_domain
  }

  backend_address_pool {
    name  = "backend-swa"
    fqdns = [var.swa_fqdn]
  }

  backend_address_pool {
    name  = "backend-apim"
    fqdns = [var.apim_fqdn]
  }

  backend_http_settings {
    name                                = "http-settings"
    cookie_based_affinity               = "Disabled"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 30
    pick_host_name_from_backend_address = true
  }

  request_routing_rule {
    name                       = "rule-web"
    rule_type                  = "Basic"
    http_listener_name         = "listener-web"
    backend_address_pool_name  = "backend-swa"
    backend_http_settings_name = "http-settings"
  }

  request_routing_rule {
    name                       = "rule-api"
    rule_type                  = "Basic"
    http_listener_name         = "listener-api"
    backend_address_pool_name  = "backend-apim"
    backend_http_settings_name = "http-settings"
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention" # Bloquea ataques
    rule_set_type    = "OWASP"
    rule_set_version = "3.0"
  }

  tags = var.tags
}
