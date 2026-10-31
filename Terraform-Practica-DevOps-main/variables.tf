# Todas las variables tienen un valor por defecto: se puede desplegar
# sin exportar nada. Si quieres personalizar, usa el prefijo TF_VAR_:
#   export TF_VAR_project_name="mi-demo"
#   export TF_VAR_location="westeurope"

variable "project_name" {
  description = "Nombre base para todos los recursos"
  type        = string
  default     = "devopsdemo"
}

variable "location" {
  description = "Región de Azure"
  type        = string
  default     = "eastus"
}
