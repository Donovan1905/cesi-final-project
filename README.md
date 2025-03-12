# Contexte Métier

Une chaîne de magasins de détail souhaite moderniser son infrastructure informatique pour mieux surveiller et gérer son inventaire. L'objectif est de disposer d'un tableau de bord web qui affiche en temps réel des indicateurs clés (niveau de stock, ventes, alertes de réapprovisionnement, etc.).

## Contraintes

* L'équipe n'est pas composée de développeurs, l'application frontale est déjà développée par vos soins.
* Le projet doit mettre en œuvre une infrastructure cloud sur Azure, automatisée via Terraform et Ansible.
* L'application doit être conteneurisée (Docker) et déployée sur un cluster Kubernetes (AKS par exemple).
* Un pipeline CI/CD (GitHub Actions) permettra d'automatiser la construction, le test et le déploiement de l'application.

## Objectifs du Projet

### Infrastructure as Code avec Terraform

* Créer un resource group, un compte de stockage, un réseau virtuel, et un cluster AKS sur Azure.

### Configuration et Provisionnement avec Ansible

* Automatiser la configuration des VM ou des ressources supplémentaires (par exemple, un serveur de monitoring ou de logging) si nécessaire.

### Conteneurisation avec Docker

* Construire une image Docker pour l'application Retail Inventory Dashboard.
* Utiliser un Dockerfile multi-stage pour optimiser la taille et la sécurité de l'image.

### Orchestration avec Kubernetes

* Déployer l'application dans le cluster AKS via des manifests Kubernetes ou via une chart Helm.
* Mettre en place des services pour exposer l'application (ClusterIP, Ingress, etc.).

### Automatisation CI/CD avec GitHub Actions

* Créer un pipeline qui :
	+ Compile et teste l'application.
	+ Construit et scanne l'image Docker (par exemple, avec Trivy).
	+ Pousse l'image sur un registre (par exemple, Azure Container Registry).
	+ Déploie ou met à jour l'application dans AKS.