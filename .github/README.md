# Projet d'évaluation — Cloud, Floci et Terraform

Déploiement de deux services AWS (S3 et DynamoDB) dans un environnement Cloud **local** simulé par **Floci**, décrits avec **Terraform** sous forme de modules.

## Sommaire

1. [Provider et services choisis](#1-provider-et-services-choisis)
2. [Prérequis](#2-prérequis)
3. [Lancer Floci](#3-lancer-floci)
4. [Lancer Floci UI](#4-lancer-floci-ui)
5. [Configuration Terraform](#5-configuration-terraform)
6. [Déploiement : init, fmt, validate, plan, apply](#6-déploiement)
7. [Vérifier les ressources dans Floci UI](#7-vérifier-les-ressources-dans-floci-ui)
8. [Destruction](#8-destruction)
9. [Terraform avec Floci vs le vrai Cloud](#9-terraform-avec-floci-vs-le-vrai-cloud)
10. [Bonus](#10-bonus)
11. [Dépannage](#11-dépannage)

---

## 1. Provider et services choisis

**Provider :** AWS

**Services :**

| Service | Rôle | Module |
|---|---|---|
| **S3** | Stockage d'objets | `modules/storage` |
| **DynamoDB** | Base de données NoSQL managée | `modules/database` |

**Pourquoi ces services ?**
- Ils représentent deux catégories très différentes de services Cloud (stockage brut et base de données), ce qui montre deux usages distincts de Terraform.
- Ce sont deux des services AWS les plus utilisés et les mieux documentés côté Terraform (`aws_s3_bucket`, `aws_dynamodb_table`).
- Ils sont pris en charge nativement par Floci, sans conteneur supplémentaire : le déploiement est rapide et fiable en local.

---

## 2. Prérequis

- Docker et Docker Compose
- Terraform **>= 1.6.0** (nécessaire pour `terraform test`)
- AWS CLI (optionnel, pour les vérifications manuelles)
- terraform-docs (optionnel, pour générer la documentation des modules)

---

## 3. Lancer Floci

Un fichier `compose.yaml` est fourni à la racine du projet :

```yaml
services:
  floci:
    image: floci/floci:latest
    ports:
      - "4566:4566"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```

Démarrage :

```bash
docker compose up -d
docker ps
```

**Port utilisé par le provider AWS : `4566`.**

Vérification que Floci répond :

```bash
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1

aws --endpoint-url http://localhost:4566 s3 ls
```

Capture : `screenshots/floci.png`

![Floci en fonctionnement](screenshots/floci.png)

---

## 4. Lancer Floci UI

Floci UI est accessible via `http://localhost:4566/_floci/ui`, qui redirige vers **`http://localhost:4500`**. Le conteneur de la console est lancé automatiquement au premier accès (cela nécessite le socket Docker monté dans `compose.yaml`).

Dans l'interface :
1. Ouvrir `http://localhost:4500`.
2. Sélectionner le cloud **AWS** (onglets AWS / Azure / GCP).
3. Explorer les services disponibles, notamment **Storage** (S3) et **DynamoDB**, qui sont ceux utilisés dans ce projet.

Capture : `screenshots/floci-ui.png`

![Floci UI](screenshots/floci-ui.png)

> Floci UI sert ici à **explorer et vérifier** les ressources. Elles sont créées uniquement avec **Terraform**.

---

## 5. Configuration Terraform

### Structure du projet

```text
cloud-project/
├── README.md
├── compose.yaml            # Lance Floci
├── main.tf                 # Appelle les deux modules
├── providers.tf            # Provider AWS pointant vers Floci
├── variables.tf            # Variables (avec validations)
├── locals.tf               # Préfixe de nommage, tags communs
├── outputs.tf              # Sorties du projet
├── versions.tf             # Versions de Terraform et du provider
├── terraform.tfvars        # Valeurs par défaut (environnement dev)
├── .terraform-docs.yml     # Configuration de terraform-docs
├── .gitignore
├── envs/
│   ├── dev.tfvars
│   └── prod.tfvars
├── modules/
│   ├── storage/            # S3
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   └── database/           # DynamoDB
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── README.md
├── tests/
│   └── main.tftest.hcl     # Tests Terraform
└── screenshots/
```

### Fichiers principaux

| Fichier | Contenu |
|---|---|
| `providers.tf` | Provider `aws` avec des identifiants factices (`test`/`test`), des `skip_*` pour ne pas contacter le vrai AWS, `s3_use_path_style` et des **endpoints** S3 et DynamoDB pointant vers `http://localhost:4566` |
| `variables.tf` | `project_name`, `environment`, `aws_region`, `floci_endpoint`, identifiants factices et `extra_tags` |
| `terraform.tfvars` | Valeurs de l'environnement `dev`, chargées automatiquement |
| `locals.tf` | `resource_prefix` (`<projet>-<env>`), `is_prod` et `common_tags` |
| `main.tf` | Appelle les modules `storage` et `database` en leur passant `local.resource_prefix` et `local.common_tags` |
| `outputs.tf` | Expose les noms et ARN du bucket et de la table |

Ressources créées avec les valeurs par défaut (`dev`) :

| Ressource | Nom |
|---|---|
| Bucket S3 | `cloud-project-dev-bucket` |
| Table DynamoDB | `cloud-project-dev-table` |

---

## 6. Déploiement

Toutes les commandes se lancent depuis la racine du projet, Floci étant démarré (section 3).

```bash
# 1. Initialiser : télécharge le provider AWS et charge les modules
terraform init

# 2. Formater le code
terraform fmt -recursive

# 3. Valider la syntaxe et la cohérence
terraform validate

# 4. Prévisualiser les changements (terraform.tfvars est chargé automatiquement)
terraform plan

# 5. Déployer
terraform apply
```

Le `plan` doit annoncer **2 ressources à créer** en `dev` (le bucket et la table). Après `apply`, les outputs s'affichent :

```text
Outputs:
storage_name    = "cloud-project-dev-bucket"
database_name   = "cloud-project-dev-table"
...
```

Pour afficher les outputs à tout moment : `terraform output`.

---

## 7. Vérifier les ressources dans Floci UI

1. Ouvrir `http://localhost:4500` et choisir **AWS**.
2. Page **Storage** : le bucket `cloud-project-dev-bucket` doit apparaître.
3. Page **DynamoDB** : la table `cloud-project-dev-table` doit apparaître avec le statut `ACTIVE`.

Vérification en ligne de commande (facultatif) :

```bash
aws --endpoint-url http://localhost:4566 s3 ls
aws --endpoint-url http://localhost:4566 dynamodb list-tables
```

Captures :

| Storage (S3) | DynamoDB |
|---|---|
| ![Bucket S3](screenshots/ressourceStorage.png) | ![Table DynamoDB](screenshots/ressourceDynamoDB.png) |

> Le bucket `test-bucket` visible sur la capture a été créé manuellement lors d'un test de Floci. Il ne fait pas partie du projet Terraform.

---

## 8. Destruction

```bash
terraform destroy
```

Terraform annonce **2 ressources à détruire**. Après confirmation, on vérifie dans Floci UI :
- la page **Storage** ne contient plus `cloud-project-dev-bucket` ;
- la page **DynamoDB** affiche « No DynamoDB found ».

Captures :

| Storage (S3) | DynamoDB |
|---|---|
| ![Destroy S3](screenshots/destroyStorage.png) | ![Destroy DynamoDB](screenshots/destroyDynamoDB.png) |

Pour arrêter Floci : `docker compose down`.

---

## 9. Terraform avec Floci vs le vrai Cloud

Le code Terraform des ressources (`aws_s3_bucket`, `aws_dynamodb_table`, modules, variables...) est **identique**. Seule la configuration du provider change.

| | Vrai AWS | Floci |
|---|---|---|
| Destination des appels API | Endpoints publics d'AWS (`s3.amazonaws.com`...) | **Endpoint local** `http://localhost:4566` |
| Identifiants | Clés IAM réelles, secrètes | Clés factices (`test`/`test`) |
| Vérifications (STS, compte, métadonnées) | Actives | Désactivées (`skip_credentials_validation`, `skip_requesting_account_id`, `skip_metadata_api_check`) |
| Adressage S3 | `bucket.s3.amazonaws.com` | Path-style (`localhost:4566/bucket`) via `s3_use_path_style` |
| Coût | Facturé | Gratuit |
| Risque | Ressources réelles, sécurité et facturation à surveiller | Aucun : tout reste sur la machine |
| Persistance | Permanente | Liée au conteneur Floci |

Cela permet d'apprendre et de tester Terraform sans compte Cloud ni coût. Pour passer sur le vrai AWS, il suffirait de retirer le bloc `endpoints`, les `skip_*` et les clés factices, puis d'utiliser de vrais identifiants.

---

## 10. Bonus

| Bonus demandé | Mis en œuvre |
|---|---|
| Validation avancée des variables | Blocs `validation` dans `variables.tf` : `project_name` (regex), `environment` (`dev` ou `prod`), `aws_region` (format), `floci_endpoint` (http/https). Validations aussi dans les modules (`name`, `hash_key_type`) |
| Bonne réutilisabilité des modules | Modules paramétrables avec valeurs par défaut : `tags`, `versioning_enabled`, `force_destroy` (S3), `hash_key`, `hash_key_type` (DynamoDB). Outputs `resource_name` et `resource_arn` |
| Environnements `dev` et `prod` | `envs/dev.tfvars` et `envs/prod.tfvars` (en prod : versioning S3 activé et tag `Criticality`) |
| Tests Terraform | `tests/main.tftest.hcl` (`terraform test`) |
| Documentation avec terraform-docs | Un `README.md` par module, généré avec terraform-docs |

### Déployer l'environnement `prod`

Chaque environnement a son propre **workspace**, donc son propre état :

```bash
terraform workspace new prod
terraform apply -var-file=envs/prod.tfvars
```

Ressources créées : `cloud-project-prod-bucket` (versioning activé) et `cloud-project-prod-table`.

Pour revenir en dev :

```bash
terraform workspace select default
terraform apply -var-file=envs/dev.tfvars
```

Pour détruire la prod : `terraform workspace select prod` puis `terraform destroy -var-file=envs/prod.tfvars`.

### Lancer les tests

```bash
terraform init
terraform test
```

Les tests utilisent `terraform plan` : rien n'est créé. Ils vérifient :
- les noms des ressources en `dev` et en `prod` ;
- qu'un environnement invalide (`staging`) est refusé ;
- qu'un nom de projet invalide (`Mon_Projet`) est refusé.

### Générer la documentation des modules

```bash
terraform-docs -c .terraform-docs.yml modules/storage
terraform-docs -c .terraform-docs.yml modules/database
```

La configuration `.terraform-docs.yml` insère un tableau des variables et des outputs entre les marqueurs `BEGIN_TF_DOCS` et `END_TF_DOCS` de chaque `README.md`.

---

## 11. Dépannage

| Problème | Solution |
|---|---|
| `connection refused` sur `localhost:4566` | Floci n'est pas démarré : `docker compose up -d` puis `docker ps` |
| Floci UI inaccessible sur `:4500` | Ouvrir d'abord `http://localhost:4566/_floci/ui` et vérifier que le socket Docker est bien monté |
| `BucketAlreadyOwnedByYou` | Un bucket du même nom existe déjà dans Floci : le supprimer (Floci UI ou `aws s3 rb`) ou relancer le conteneur |
| `terraform validate` signale une variable invalide | Vérifier `terraform.tfvars` (nom en minuscules, `environment` = `dev` ou `prod`) |
| Ressources absentes après redémarrage de Floci | Normal : l'état de Floci est lié au conteneur. Relancer `terraform apply` |
