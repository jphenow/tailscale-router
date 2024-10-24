`fly secrets set TS_AUTHKEY="tskey-"`

largely a copy from: https://github.com/fly-apps/tailscale-router
And https://community.fly.io/t/connecting-your-fly-apps-to-your-tailscale-tailnet/17828
and https://tailscale.com/kb/1132/flydotio

# Deploy

```bash
fly deploy
```

# Setup

## Get org IP range

Login to an app on fly and run `dig aaaa myapp.internal`

```
; <<>> DiG 9.18.13 <<>> aaaa jphenow-tailscale.internal
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 9363
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;jphenow-tailscale.internal.    IN      AAAA

;; ANSWER SECTION:
jphenow-tailscale.internal. 5   IN      AAAA    fdaa:0:2b6:a7b:98:6caf:4221:2
```
For this my org IP range is `fdaa:0:2b6::/48`

## Deploy this

Set your routes (fly.io) to the internal fly dns and advertise all org routes:

```
TS_ROUTES = "fdaa::3/128,fdaa:0:2b6::/48"
```

`fly deploy`

## Setup Tailscale

On tailscale admin enable subnet advertising on the machine then under magic DNS add `fdaa::3` as a DNS server.

You should be able to access `yourapp.internal` from any machine on your tailscale network.
