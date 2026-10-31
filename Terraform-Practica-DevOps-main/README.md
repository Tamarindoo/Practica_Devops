# Terraform · Azure Function básica (rápido, sin Service Principal)

Despliega lo mínimo para tener una Azure Function corriendo: Resource Group +
Storage Account + App Service Plan (consumo) + Function App.

No usa Service Principal ni App Registration — se autentica con tu sesión
de Azure CLI. Nada de credenciales guardadas en el código.

## Requisitos

- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) instalado
- [Terraform](https://developer.hashicorp.com/terraform/install) instalado

## Pasos (3 comandos y listo)

```bash
# 1) Iniciar sesión en Azure (abre el navegador una sola vez)
az login

# 2) Inicializar Terraform
terraform init

# 3) Desplegar
terraform apply
```

Eso es todo — no hay que exportar `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET` ni
crear ningún registro de aplicación. Terraform usa la sesión que `az login`
ya dejó activa en tu máquina.

> Si tu cuenta tiene más de una suscripción de Azure, indica cuál usar:
> `az account set --subscription "<nombre o id>"` antes del `terraform apply`.

## Personalizar (opcional)

Todo tiene un valor por defecto. Si quieres cambiar el nombre del proyecto
o la región, usa variables de entorno con el prefijo `TF_VAR_`:

```bash
export TF_VAR_project_name="mi-demo"
export TF_VAR_location="westeurope"
```

## El ciclo DevOps con este proyecto

```bash
terraform plan        # vista previa (diagnóstico antes de aplicar)
terraform apply       # deploy
# ... si algo falla, se corrige el .tf (fix) ...
terraform apply       # redeploy
terraform show        # validación
terraform destroy     # elimina todo cuando ya no se necesite
```

## Archivos

| Archivo         | Contenido                                             |
|------------------|--------------------------------------------------------|
| `main.tf`        | Provider (auth por Azure CLI) y los recursos de Azure  |
| `variables.tf`   | Variables con valores por defecto                       |
| `outputs.tf`     | Datos que se muestran al terminar el `apply`            |
| `.gitignore`     | Evita subir el estado de Terraform a Git                |
