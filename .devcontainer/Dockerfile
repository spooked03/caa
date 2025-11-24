FROM ubuntu:24.04

# 1. Install Base Dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gpg \
    git \
    unzip \
    ca-certificates \
    lsb-release \
    apt-transport-https \
    vim \
    age \
    jq \
    fish \
    && rm -rf /var/lib/apt/lists/*

# 2. Install OpenTofu
RUN curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o /tmp/install-opentofu.sh && \
    chmod +x /tmp/install-opentofu.sh && \
    /tmp/install-opentofu.sh --install-method deb --install-path /usr/local/bin && \
    rm /tmp/install-opentofu.sh

# 3. Install sops
RUN curl -LO https://github.com/getsops/sops/releases/download/v3.11.0/sops-v3.11.0.linux.amd64 && \
    mv sops-v3.11.0.linux.amd64 /usr/local/bin/sops && \
    chmod +x /usr/local/bin/sops

# 4. Install OVF Tool
COPY .devcontainer/VMware-ovftool-linux.zip /tmp/

# Unzip and install
RUN unzip /tmp/VMware-ovftool-linux.zip -d /usr/local/lib/ && \
    chmod +x /usr/local/lib/ovftool/ovftool && \
    chmod +x /usr/local/lib/ovftool/ovftool.bin && \
    ln -s /usr/local/lib/ovftool/ovftool /usr/local/bin/ovftool && \
    rm /tmp/VMware-ovftool-linux.zip

RUN chsh -s /usr/bin/fish

WORKDIR /workspace