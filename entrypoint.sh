#!/bin/sh

set -e

mkdir -p /opt/caddy
export CADDY_FILE=/opt/caddy/caddyfile

if [ -z "${DOMAIN_NAME}" ]; then
  DOMAIN_NAME=localhost
fi

if [ -z "${PROXY_URL}" ]; then
  echo "PROXY_URL is a required environment variable"
  exit 1;
fi

CA_ARG=""
EMAIL_ARG=""

if [ ! -z "${EMAIL_ADDRESS}" ]; then
  echo "Specifying the email address"
  EMAIL_ARG="-email ${EMAIL_ADDRESS}"
fi

if [ ! -z "${CA_URL}" ]; then
  echo "Specifying the CA URL as ${CA_URL}"
  CA_ARG="-ca ${CA_URL}"
fi

cat > ${CADDY_FILE} <<- EOF
${DOMAIN_NAME} {
  log stdout
  errors stdout

  header / -Server

  proxy / ${PROXY_URL} {
    transparent
    websocket
  }
}
EOF

echo "===Caddyfile==="
cat ${CADDY_FILE}
echo "==============="

caddy -conf ${CADDY_FILE} \
  ${CA_ARG} \
  ${EMAIL_ARG}
