FROM tailscale/tailscale

RUN apk update && apk add --no-cache bash caddy ca-certificates iptables ip6tables curl && rm -rf /var/cache/apk/*

COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /app/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

COPY start.sh /usr/local/bin/start.sh

CMD /usr/local/bin/start.sh
