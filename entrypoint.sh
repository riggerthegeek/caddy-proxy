#!/bin/bash

set -e

mkdir -p /opt/caddy
export CADDY_FILE=/opt/caddy/caddyfile

if [ -z "${PROXY_CSV}" ]; then
  echo "PROXY_CSV is a required environment variable"
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

echo ${PROXY_CSV}

IFS=', ' read -r -a array <<< "${PROXY_CSV}"

for element in "${array[@]}"
do
  IFS='=' read -r -a item <<< "${element}"
  DOMAIN_NAME=${item[0]}
  PROXY_URL=${item[1]}

  cat >> ${CADDY_FILE} <<- EOF
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
done

echo "===Caddyfile==="
cat ${CADDY_FILE}
echo "==============="

caddy -conf ${CADDY_FILE} \
  -agree \
  ${CA_ARG} \
  ${EMAIL_ARG}
