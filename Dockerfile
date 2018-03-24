FROM alpine:latest

LABEL maintainer="Simon Emms <simon@simonemms.com>"

WORKDIR /opt
ADD entrypoint.sh .
RUN chmod 755 entrypoint.sh

ARG CADDY_URL=https://getcaddy.com
ARG CADDY_LICENSE=personal
ARG CADDY_PLUGINS=""
ARG CADDY_ACCESS_CODES=""

# Set these if using a commercial license
ARG CADDY_ACCOUNT_ID=""
ARG CADDY_API_KEY=""

ENV CADDYPATH=/opt/certs
ENV DOMAIN_NAME=""
ENV EMAIL_ADDRESS=""
ENV PROXY_URL=""

ENV CADDY_ACCOUNT_ID=${CADDY_ACCOUNT_ID}
ENV CADDY_API_KEY=${CADDY_API_KEY}

VOLUME ${CADDYPATH}

RUN apk add --no-cache bash curl gnupg \
  && curl ${CADDY_URL} | bash -s ${CADDY_LICENSE} ${CADDY_PLUGINS} ${CADDY_ACCESS_CODES} \
  && apk del bash curl gnupg

# Validate install
RUN caddy -version \
  && caddy -plugins

EXPOSE 80 443 2015

ENTRYPOINT [ "/opt/entrypoint.sh" ]