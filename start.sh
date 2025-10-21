#!/usr/bin/env bash

set -euo pipefail

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding

# Check auth key
if [[ -z "${TS_AUTHKEY:-}" ]]; then
    echo "ERROR: TS_AUTHKEY environment variable not set"
    exit 1
fi

# Start tailscaled
/app/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &

sleep 3

# Connect to tailscale
echo "Attempting to connect to Tailscale..."
if ! /app/tailscale up --authkey=$TS_AUTHKEY $TS_EXTRA_ARGS --hostname=$TS_HOSTNAME --advertise-routes=$TS_ROUTES; then
    echo "ERROR: Failed to authenticate with Tailscale"
    exit 1
fi

echo "Tailscale connected successfully"

# Validate Caddyfile
echo "Validating Caddyfile..."
caddy validate --config /usr/local/bin/Caddyfile

# Start Caddy
echo "Starting Caddy with config file..."
caddy run --config /usr/local/bin/Caddyfile &

wait
