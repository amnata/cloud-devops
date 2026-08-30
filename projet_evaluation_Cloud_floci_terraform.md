# Projet d'évaluation — Cloud, Floci et Terraform

## 1. Objectif

L'objectif de ce projet est de vérifier votre capacité à :

- lancer un environnement Cloud local avec **Floci** ;
- utiliser **Floci UI** pour explorer les services disponibles ;
- choisir un **Cloud Provider** ;
- sélectionner **deux services Cloud** proposés par ce provider ;
- utiliser **Terraform** pour décrire et déployer ces services ;
- organiser un projet Terraform avec des **modules**, des **variables**, des fichiers `.tfvars`, des `locals` et des `outputs` ;
- vérifier dans Floci UI que les ressources ont bien été créées ;
- détruire proprement les ressources avec Terraform.

Le projet ne demande **pas de construire une architecture Cloud complète**.

---

## 2. Travail demandé

Chaque étudiant  doit choisir **un Cloud Provider supporté par Floci** :

- AWS
- Azure
- GCP
- OCI

Vous devez ensuite sélectionner **deux services Cloud** disponibles pour ce provider.

> Exemple : avec AWS, vous pouvez choisir S3 et DynamoDB.

Le choix des services doit être indiqué dans le README et justifié en quelques lignes.

---

## 3. Étape 1 — Installation et lancement de Floci

Vous devez installer et lancer Floci sur votre machine.

Vous devez être capable de montrer que Floci fonctionne correctement.

### Travail demandé

1. Installer Floci.
2. Démarrer Floci.
3. Identifier le port utilisé par le provider choisi.
4. Vérifier que le service fonctionne.

Vous devez fournir dans le rapport :

- les commandes utilisées ;
- une capture d'écran montrant Floci en fonctionnement.

### Références

- Floci — GitHub : https://github.com/floci-io/floci
- Site officiel de Floci : https://floci.io/

---

## 4. Étape 2 — Lancement de Floci UI

Vous devez ensuite installer et lancer **Floci UI**.

Floci UI fournit une interface graphique permettant d'explorer les services Cloud disponibles dans votre environnement local.

### Travail demandé

1. Lancer Floci UI.
2. Accéder à l'interface Web.
3. Identifier le Cloud Provider choisi.
4. Explorer les services disponibles.
5. Identifier les deux services que vous allez utiliser pour votre projet Terraform.

L'interface est généralement accessible à :

```text
http://localhost:4500
```

### Référence

- Floci UI — GitHub : https://github.com/floci-io/floci-ui

> **Important :** Floci UI est utilisé ici pour explorer et vérifier les ressources. Les ressources demandées dans le projet doivent être créées avec **Terraform**.

---

## 5. Étape 3 — Choix du Provider et des services

Choisissez un provider :

```text
AWS
Azure
GCP
OCI
```

Puis choisissez **deux services**.

### Exemple AWS

```text
Provider : AWS

Service 1 : S3
Service 2 : DynamoDB
```

### Exemple Azure

```text
Provider : Azure

Service 1 : Blob Storage
Service 2 : Cosmos DB
```

Le choix doit tenir compte des services effectivement supportés par votre version de Floci.

---

## 6. Étape 4 — Création du projet Terraform

Organisez votre projet avec la structure suivante :

```text
cloud-project/
│
├── main.tf
├── providers.tf
├── variables.tf
├── locals.tf
├── outputs.tf
├── versions.tf
├── terraform.tfvars
│
└── modules/
    │
    ├── service1/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── service2/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

Les noms `service1` et `service2` doivent être remplacés par des noms adaptés aux services choisis.

---

## 7. Étape 5 — Configuration du Provider

Configurez Terraform afin qu'il communique avec **Floci** et non avec le véritable Cloud Provider.

Le fichier `providers.tf` doit contenir la configuration nécessaire au provider choisi.

L'objectif est notamment de comprendre la notion d'**endpoint local**.

Vous devez être capable d'expliquer :

> Quelle est la différence entre utiliser Terraform avec le véritable Cloud Provider et utiliser Terraform avec Floci ?

---

## 8. Étape 6 — Utilisation des variables

Le projet doit utiliser des variables Terraform.

Exemple :

```hcl
variable "project_name" {
  type        = string
  description = "Nom du projet"
}

variable "environment" {
  type        = string
  description = "Environnement"
}
```

Les valeurs ne doivent pas être inutilement écrites en dur dans les ressources.

---

## 9. Étape 7 — Utilisation de `terraform.tfvars`

Créez un fichier :

```text
terraform.tfvars
```

Exemple :

```hcl
project_name = "cloud-project"
environment  = "dev"
```

Vous devez utiliser ce fichier lors du déploiement.

---

## 10. Étape 8 — Utilisation des `locals`

Le projet doit contenir au moins un bloc `locals`.

Exemple :

```hcl
locals {
  resource_prefix = "${var.project_name}-${var.environment}"
}
```

Ce local devra être utilisé dans la définition d'au moins une ressource.

---

## 11. Étape 9 — Création des modules

Les deux services doivent être organisés sous forme de **modules Terraform**.

Exemple :

```text
modules/
├── storage/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
└── database/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

Dans le fichier `main.tf` principal :

```hcl
module "storage" {
  source = "./modules/storage"

  name = local.resource_prefix
}

module "database" {
  source = "./modules/database"

  name = local.resource_prefix
}
```

Le but est de montrer que vous savez **séparer et réutiliser la configuration Terraform**.

---

## 12. Étape 10 — Outputs

Chaque module doit fournir au moins un `output`.

Exemple :

```hcl
output "resource_name" {
  value = aws_s3_bucket.this.id
}
```

Le fichier principal doit également exposer les informations importantes.

Exemple :

```hcl
output "storage_name" {
  value = module.storage.resource_name
}
```

---

## 13. Étape 11 — Validation et déploiement

Vous devez exécuter au minimum les commandes suivantes :

```bash
terraform init
```

```bash
terraform fmt
```

```bash
terraform validate
```

```bash
terraform plan
```

```bash
terraform apply
```

Après le déploiement, vérifiez les ressources dans **Floci UI**.

Vous devez fournir une capture d'écran montrant les deux services créés.

---

## 14. Étape 12 — Destruction

Une fois les ressources vérifiées, vous devez les supprimer avec :

```bash
terraform destroy
```

Vérifiez ensuite dans Floci UI que les ressources ont bien disparu.

---

## 15. Livrable

Vous devez rendre un dépôt Git contenant :

```text
cloud-project/
│
├── README.md
├── main.tf
├── providers.tf
├── variables.tf
├── locals.tf
├── outputs.tf
├── versions.tf
├── terraform.tfvars
│
├── modules/
│   ├── service1/
│   └── service2/
│
└── screenshots/
    ├── floci.png
    ├── floci-ui.png
    ├── resources.png
    └── destroy.png
```

---

## 16. README

Le `README.md` doit expliquer brièvement :

1. Le provider choisi.
2. Les deux services choisis.
3. Pourquoi ces services ont été choisis.
4. Comment lancer Floci.
5. Comment lancer Floci UI.
6. Comment configurer Terraform.
7. Comment effectuer :
   - `terraform init`
   - `terraform validate`
   - `terraform plan`
   - `terraform apply`
   - `terraform destroy`
8. Comment vérifier les ressources dans Floci UI.

Le README doit permettre à une autre personne de reproduire le projet.

---

## 17. Éléments obligatoires

| Élément | Obligatoire |
|---|---:|
| Floci | Oui |
| Floci UI | Oui |
| Cloud Provider | Oui |
| 2 services Cloud | Oui |
| Terraform | Oui |
| `provider` | Oui |
| Variables | Oui |
| `terraform.tfvars` | Oui |
| `locals` | Oui |
| Modules | Oui |
| Outputs | Oui |
| `terraform init` | Oui |
| `terraform validate` | Oui |
| `terraform plan` | Oui |
| `terraform apply` | Oui |
| `terraform destroy` | Oui |
| Vérification dans Floci UI | Oui |

---

## 18. Évaluation — /20

| Critère | Points |
|---|---:|
| Installation et lancement de Floci | 2 |
| Lancement et utilisation de Floci UI | 2 |
| Choix et compréhension du provider | 2 |
| Choix et utilisation des deux services | 3 |
| Configuration Terraform / provider | 2 |
| Variables et `terraform.tfvars` | 2 |
| Utilisation des `locals` et `outputs` | 2 |
| Création et utilisation des modules | 3 |
| Déploiement et vérification dans Floci UI | 1 |
| Documentation / README | 1 |
| **Total** | **20** |

### Bonus — +2 points maximum

- validation avancée des variables ;
- bonne réutilisabilité des modules ;
- utilisation d'environnements `dev` et `prod` ;
- ajout de tests Terraform ;
- documentation particulièrement claire des modules avec  l'outil terraform-docs.

---

## 19. Références

### Floci

- Site officiel : https://floci.io/
- GitHub : https://github.com/floci-io/floci

### Floci UI

- GitHub : https://github.com/floci-io/floci-ui

### Terraform

- Documentation : https://developer.hashicorp.com/terraform/docs
- Providers : https://developer.hashicorp.com/terraform/language/providers
- Modules : https://developer.hashicorp.com/terraform/language/modules
- Variables : https://developer.hashicorp.com/terraform/language/values/variables
- Locals : https://developer.hashicorp.com/terraform/language/values/locals
- Outputs : https://developer.hashicorp.com/terraform/language/values/outputs

---


