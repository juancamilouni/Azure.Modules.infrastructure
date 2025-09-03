resource "azurerm_application_gateway" "agw" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = "WAF_Medium" # ✅ Calidad-precio: WAF v1 (más barato que WAF v2)
    tier     = "WAF"
    capacity = var.capacity # Escalable: 2-5 instancias
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = var.public_ip_id
  }

  backend_address_pool {
    name = "backend-pool"
    backend_addresses {
      ip_address = var.backend_ip
    }
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule-1"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "http-settings"
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"

    # 🔒 Recomendación: Habilitar en prod
    # disabled_rule_group {
    #  rule_group_name = "REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION"
    #  rules           = ["943100"]  # Puedes comentar esta sección en prod
    #}
  }

  tags = var.tags
}
