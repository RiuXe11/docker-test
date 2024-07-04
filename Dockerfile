# syntax=docker/dockerfile:1
FROM debian:11.7

# Mettre à jour et installer les dépendances nécessaires
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    gnupg2 \
    ca-certificates \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Ajouter les clés Microsoft et le dépôt de paquets pour Debian 11
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /usr/share/keyrings/microsoft-archive-keyring.gpg > /dev/null \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/debian/11/prod bullseye main" > /etc/apt/sources.list.d/microsoft-prod.list

# Mettre à jour les paquets et installer le SDK .NET
RUN apt-get update && apt-get install -y dotnet-sdk-8.0

# Cloner le dépôt et définir le répertoire de travail
RUN git clone https://github.com/Aif4thah/VulnerableLightApp.git /app
WORKDIR /app

# Restaurer les dépendances et construire le projet
RUN dotnet restore
RUN dotnet build -c Release

# Commande par défaut pour exécuter l'application
CMD ["dotnet", "run"]
