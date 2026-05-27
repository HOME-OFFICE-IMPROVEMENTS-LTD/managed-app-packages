#!/bin/bash
# Dokku install script for Azure Managed Application
# Installs Dokku via official bootstrap, configures for headless/unattended use
set -e

DOKKU_VERSION=${1:-0.35.15}
SSH_PUBLIC_KEY=${2:-}

echo "==> Installing Dokku v${DOKKU_VERSION} on Ubuntu 24.04"

# Ensure system is up to date
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y wget curl

# Download and run official Dokku bootstrap
wget -q "https://raw.githubusercontent.com/dokku/dokku/v${DOKKU_VERSION}/bootstrap.sh" -O /tmp/bootstrap.sh
DOKKU_TAG="v${DOKKU_VERSION}" bash /tmp/bootstrap.sh

# Register SSH public key with Dokku (enables git push deployments)
if [ -n "$SSH_PUBLIC_KEY" ]; then
  echo "$SSH_PUBLIC_KEY" | dokku ssh-keys:add admin
  echo "==> SSH key registered with Dokku"
fi

# Configure global domain — retry IMDS up to 5 times (IMDS may not be ready at boot)
DOMAIN=""
for i in 1 2 3 4 5; do
  DOMAIN=$(curl -sf --max-time 5 -H "Metadata:true" \
    "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/publicIpAddress?api-version=2021-02-01&format=text" 2>/dev/null || true)
  [ -n "$DOMAIN" ] && break
  echo "  Waiting for IMDS (attempt $i/5)..."
  sleep 5
done

# Fall back to short hostname if IMDS unavailable
DOMAIN="${DOMAIN:-$(hostname -s)}"

if [ -n "$DOMAIN" ]; then
  dokku domains:set-global "$DOMAIN"
  echo "==> Global domain set to: $DOMAIN"
else
  echo "==> Warning: could not determine domain, skipping domains:set-global"
fi

echo "==> Dokku v${DOKKU_VERSION} installation complete"
echo "    Push your app:  git remote add azure dokku@${DOMAIN}:<appname>"
echo "    Create an app:  dokku apps:create <appname>"
