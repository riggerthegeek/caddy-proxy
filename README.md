# Caddy Proxy

Caddy server configured to proxy to another URL 
 
# Usage

This can be demonstrated by running the Docker Compose application. This
will use Caddy to proxy the nginx server, which is not publicly
accessible.

```bash
docker-compose up
```

Now, in a browser, go to [localhost:2015](http://localhost:2015). You
should see the nginx welcome page.

# Environment Variables

- **CADDYPATH**: The path to store SSL certificates. This should be
  configured as a volume so certificates are not generated every time.
  _Defaults to `/opt/certs`_.
- **CA_URL**: The certificate authority URL. By default, this is empty
  and will generate a Lets Encrypt production certificate. Use
  `https://acme-staging-v02.api.letsencrypt.org/directory` if you want to
  generate a staging certificate.
- **EMAIL_ADDRESS**: Admin email for the SSL certificate.
- **PROXY_CSV**: CSV of URLs to proxy. Can be an external URL or on a
 private network, eg `domain.com=proxy.url:1234,domain.io=proxy.url:9999`

