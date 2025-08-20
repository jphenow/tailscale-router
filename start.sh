#!/usr/bin/env bash

set -euo pipefail

/app/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
/app/tailscale up --authkey=$TS_AUTHKEY $TS_EXTRA_ARGS --hostname=$TS_HOSTNAME --advertise-routes=$TS_ROUTES

# sh -c "export PATH=$PATH:/usr/local/bin; containerboot" &
caddy reverse-proxy --from :4000 --to flyio:4000 --insecure &
caddy reverse-proxy --from :2283 --to daggett:2283 --insecure
