FROM ubuntu:22.04

# Test for ForgeJo
ENV DEBIAN_FRONTEND=noninteractive

# Basisgereedschap
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    openssh-client \
    python3 \
    python3-pip \
    vim \
    jq \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Locale instellen — zonder dit klaagt Ansible bij elke aanroep met
# "could not initialize the preferred locale: unsupported locale setting",
# omdat een kaal Ubuntu-basisimage geen enkele locale heeft gegenereerd en
# de locale-omgevingsvariabelen die vanuit je WSL-terminal de container in
# lekken (bijvoorbeeld LANG=en_US.UTF-8) daardoor naar iets niet-bestaands wijzen.
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# SSH-hostkey-verificatie overslaan voor elke verbinding die de container opzet.
# Zonder dit zou elke ssh/scp-verbinding (bijvoorbeeld naar Proxmox of de k3s-VM)
# proberen de hostkey weg te schrijven naar ~/.ssh/known_hosts, en die map is
# bewust read-only gemount (zie dev.sh, stap 9) — dat mislukt dus altijd. Omdat
# VM's in dit project bovendien regelmatig via `tofu destroy`/`tofu apply`
# opnieuw worden opgebouwd (met een nieuwe hostkey op hetzelfde IP), zou strikte
# hostkey-verificatie toch telkens opnieuw een handmatige "yes"-bevestiging
# vragen — dezelfde afweging als `host_key_checking = False` in Ansible's
# ansible.cfg (document 4a), maar dan voor losse ssh/scp-commando's.
RUN printf 'Host *\n    StrictHostKeyChecking accept-new\n    UserKnownHostsFile /dev/null\n' >> /etc/ssh/ssh_config

# OpenTofu
RUN curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o /tmp/install-opentofu.sh \
    && chmod +x /tmp/install-opentofu.sh \
    && /tmp/install-opentofu.sh --install-method standalone \
    && rm /tmp/install-opentofu.sh

# Ansible
RUN pip3 install --no-cache-dir ansible

# kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Helm
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Toevoegen aan .devcontainer/Dockerfile, na de bestaande installatiestappen
RUN apt-get update && apt-get install -y --no-install-recommends apache2-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace