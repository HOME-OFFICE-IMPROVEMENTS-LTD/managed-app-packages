#!/bin/bash
# Dokku install script for Azure Managed Application
# Installs Dokku via official bootstrap, configures for headless/unattended use
set -e

DOKKU_VERSION=${1:-0.35.15}

echo "==> Installing Dokku v${DOKKU_VERSION} on Ubuntu 24.04"

# Ensure system is up to date
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y wget curl

# Download and run official Dokku bootstrap
wget -q "https://raw.githubusercontent.com/dokku/dokku/v${DOKKU_VERSION}/bootstrap.sh" -O /tmp/bootstrap.sh
DOKKU_TAG="v${DOKKU_VERSION}" bash /tmp/bootstrap.sh

# Configure Dokku for unattended / headless use (no web setup wizard)
dokku domains:set-global "$(curl -s -H Metadata:true 'http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/publicIpAddress?api-version=2021-02-01&format=text' 2>/dev/null || hostname -f)"

echo "==> Dokku v${DOKKU_VERSION} installation complete"
echo "    Push your app:  git remote add azure dokku@<hostname>:<appname>"
echo "    Create an app:  dokku apps:create <appname>"
