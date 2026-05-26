# Azure Modules Infrastructure – Precredit

## Descripción general

Este repositorio contiene los módulos reutilizables de Terraform que implementan la infraestructura básica y de plataforma para el proyecto Precredit en Microsoft Azure. Cada módulo encapsula la creación y configuración de un recurso o conjunto de recursos (por ejemplo, redes, identidades, Container Apps, API Management, etc.). Al versionar y consumir estos módulos desde otros repositorios (mediante Terragrunt o Terraform), se garantiza consistencia en la implementación, reutilización de código y facilidad de mantenimiento.

---

# Tipo de infraestructura

La solución Precredit aprovecha tanto servicios IaaS como PaaS de Azure:

## IaaS

- Redes virtuales (Virtual Network)
- Subredes
- Grupos de seguridad (NSG)
- Direcciones IP públicas
- Cuentas de almacenamiento para estados remotos

Estos recursos proporcionan la base de red y seguridad sobre la cual se despliegan otros servicios.

## PaaS

- Azure Container Apps
- Azure Container Registry (ACR)
- Azure API Management
- Azure Key Vault
- Application Gateway
- Azure Static Web Apps

Algunos módulos específicos implementan integraciones como SonarQube.

La combinación de ambos tipos de servicios permite diseñar una plataforma flexible y escalable manteniendo buenas prácticas de seguridad y cumplimiento.

---

# Estructura de los módulos

Cada módulo reside en su propio directorio con la siguiente estructura estándar:

| Archivo | Descripción |
|---|---|
| main.tf | Define los recursos de Azure y sus relaciones. |
| variables.tf | Declara las variables de entrada (obligatorias y opcionales). Las variables comunes (subscription_id, tenant_id, location y resource_group_name) se repiten en casi todos los módulos para mantener uniformidad. |
| outputs.tf | Expone valores útiles (ID, nombres, URIs) que pueden ser consumidos por otros módulos o scripts. |
| provider.tf | Declara el proveedor azurerm y cualquier otro provider necesario. Cuando se utiliza Terragrunt no es imprescindible, pero permite ejecutar el módulo con terraform de manera aislada. |

---

# Principales módulos disponibles

Los módulos se agrupan a continuación por categoría. Esta lista no es exhaustiva pero ofrece una visión general de las capacidades ofrecidas.

| Categoría | Módulos principales | Descripción |
|---|---|---|
| Red y seguridad | networking, nsg, public_ip, application_gateway, application_gateway_pre, application_gateway_qa | Proporcionan redes virtuales con subredes, asociaciones a grupos de seguridad (NSG) y direcciones IP públicas. El módulo networking permite declarar un arreglo de subredes con prefijos y, si se requiere, activa un Network Watcher. Los módulos de application_gateway implementan Gateways de aplicación para distintos ambientes. |
| Identidad y control de acceso | identity, keyvault, role_assignment | Crean identidades administradas de Azure AD que se usan en otros recursos; despliegan Azure Key Vault con características de RBAC, políticas de retención y certificados opcionales; y asignan roles a identidades o servicios. |
| Contenedores y microservicios | Containerregistries (ACR), containerapps_environment, containerapps_cloud, containerapps_core, containerapps_gateway, containerapps_list, containerapps_payment, containerapps_prequalificationflow, containerapps_product, containerapps_sonarqube | Implementan un Azure Container Registry para almacenar imágenes y una serie de módulos de Azure Container Apps que representan microservicios de Precredit. Cada módulo define variables para el nombre de la app, la imagen del contenedor, el puerto de escucha, la configuración de escalado y las variables de entorno/secretos que la app necesita. El módulo containerapps_environment crea el entorno de ejecución común para todas las apps. |
| API y front-end | apim_backend_api_dev, apim_backend_api_pre, apim_backend_api_qa, apim_instance_public_dev, static_web_app, static_web_app_bo | Configuran instancias de Azure API Management y despliegan APIs backend separadas por ambiente. También crean aplicaciones de Azure Static Web Apps para servir tanto el sitio público como el back-office de Precredit. |
| Bases de datos y persistencia | postgresql_flexible_server, cosmosdb_mongodb, storage_account | La plataforma utiliza Azure Database for PostgreSQL Flexible Server y Azure Cosmos DB for MongoDB para el almacenamiento de información transaccional y logs de aplicación. Los ambientes dev, qa y prod comparten la misma estructura lógica y esquemas definidos por la aplicación, permitiendo mantener consistencia entre entornos y simplificar procesos de despliegue, validación y migración. Además, se utilizan cuentas de almacenamiento para archivos, respaldos y manejo de estados remotos de Terraform. |
| Almacenamiento y estado | storage_state, resource_group, resource_groups | Gestionan las cuentas de almacenamiento utilizadas para guardar los estados remotos de Terraform y crear uno o varios grupos de recursos. Esto centraliza la administración del estado y facilita la recuperación en caso de fallo. |
| Otros | sonarqube_azure, containerapps_sonarqube | Permiten desplegar SonarQube, ya sea en una máquina virtual (IaaS) o en una Container App (PaaS), para integrarlo en la cadena de calidad de Precredit. |

---

# Convenciones de variables y etiquetas

Los módulos comparten un conjunto de variables comunes para fomentar la reutilización y la coherencia. Entre ellas:

- subscription_id y tenant_id: identificación de la suscripción y del directorio de Azure. Son parámetros obligatorios y suelen proveerse desde el entorno de despliegue.
- location: región donde se desplegará el recurso. Se recomienda mantener una sola región por ambiente para reducir latencia y simplificar la configuración.
- resource_group_name: nombre del grupo de recursos donde se agruparán los recursos generados. Precredit sugiere crear grupos por dominio o servicio, y nombrarlos con el prefijo del proyecto y el ambiente.
- tags: mapa de etiquetas clave/valor. Los módulos permiten agregar etiquetas como Project, environment y Owner para facilitar la gobernanza y el seguimiento de costes.

---

# Cómo utilizar los módulos

Los módulos de este repositorio están pensados para ser consumidos desde el repositorio Azure.infrastructure.IaaS mediante Terragrunt. Sin embargo, también pueden ser usados directamente con Terraform. A continuación se presentan ejemplos de uso en ambos casos.

---

# Uso con Terragrunt

Cada subcarpeta del repositorio Terragrunt define un archivo terragrunt.hcl que incluye el módulo de este repositorio.

## Ejemplo simplificado

```hcl
# terragrunt.hcl para el módulo networking en ambiente dev

include {
  path = find_in_parent_folders("terragrunt_azure.hcl")
}

locals {
  common_vars = yamldecode(file("../common_vars.yaml"))
}

dependency "nsg" {
  config_path = "../nsg"
}

terraform {
  # La URL se sobrescribe en tiempo de ejecución con un token temporal
  source = "git::https://github.com/juancamilouni/Azure.Modules.infrastructure//networking?ref=v0.1.0"
}

inputs = {
  vnet_name            = "${local.common_vars.project_name}-networking-${local.common_vars.environment}"
  location             = local.common_vars.azure.region
  resource_group_name  = local.common_vars.rg_roles.network
  subscription_id      = local.common_vars.azure.subscription_id
  tenant_id            = local.common_vars.azure.tenant_id
  address_space        = local.common_vars.network.address_space
  subnets              = [/* lista de subredes */]

  tags = {
    Tipo_Recurso = "VirtualNetwork"
    environment  = local.common_vars.environment
    Owner        = "nombre@empresa.com"
    Project      = local.common_vars.project_name
  }
}

En este ejemplo, la sección source apunta al módulo networking de este repositorio en una versión específica. Durante los workflows de GitHub Actions, esta URL se actualiza para incluir un token temporal que permite clonar el repositorio privado.

Uso directo con Terraform

También es posible invocar los módulos sin Terragrunt. En ese caso hay que definir manualmente el backend, el proveedor y las variables.

Ejemplo
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.104"
    }
  }
}

provider "azurerm" {
  features {}
}

module "vnet" {
  source              = "git::https://github.com/juancamilouni/Azure.Modules.infrastructure//networking?ref=v0.1.0"

  subscription_id     = "<tu_subscription_id>"
  tenant_id           = "<tu_tenant_id>"
  vnet_name           = "precredit-networking-dev"
  location            = "eastus2"
  resource_group_name = "rg-networking-dev"

  address_space       = ["10.0.0.0/16"]

  subnets = [
    {
      name             = "subnet1"
      address_prefixes = ["10.0.1.0/24"]
    },
    {
      name             = "subnet2"
      address_prefixes = ["10.0.2.0/24"]
    }
  ]

  tags = {
    Project     = "precredit"
    environment = "dev"
    Owner       = "nombre@empresa.com"
  }
}
```
## Gestión de variables y secretos

Para mantener las credenciales y configuraciones sensibles fuera del código fuente, los valores de variables como subscription_id, tenant_id o contraseñas se almacenan en GitHub Secrets o en variables de entorno de los workflows.

El repositorio Terragrunt genera un archivo common_vars.yaml a partir de una plantilla y de estas variables, de manera que los módulos reciben sus entradas desde un único lugar.

De este modo se asegura que ninguna clave secreta o contraseña quede expuesta en los archivos del repositorio.

##  Conclusión

El repositorio Azure.Modules.infrastructure constituye la base reutilizable de la infraestructura de Precredit.

Al encapsular cada recurso en módulos versionados y bien documentados, facilita la administración de entornos complejos en Azure, reduce la duplicación de código y promueve una gobernanza clara.

Su estrecha integración con el repositorio de Terragrunt y los pipelines de CI/CD permite desplegar la infraestructura de manera consistente y segura.
