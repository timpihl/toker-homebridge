FROM amd64/node:latest

RUN apt-get update && apt-get install -y \ 
   git \
   python \
   make \
   g++ \
   libnss-mdns \
   avahi-discover \
   libavahi-compat-libdnssd-dev \
   inetutils-ping sudo nano \
   && apt-get clean \
   && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* \
   && chmod 4755 /bin/ping \
   && mkdir /homebridge \
   && npm set global-style=true \
   && npm set package-lock=false

ENV HOMEBRIDGE_VERSION=latest
RUN npm install -g --unsafe-perm homebridge@${HOMEBRIDGE_VERSION}

ENV CONFIG_UI_VERSION=4.6.3 HOMEBRIDGE_CONFIG_UI=0 HOMEBRIDGE_CONFIG_UI_PORT=7070
RUN npm install -g --unsafe-perm homebridge-config-ui-x@${CONFIG_UI_VERSION}

WORKDIR /homebridge
VOLUME /homebridge

COPY root /

ARG AVAHI
RUN [ "${AVAHI:-1}" = "1" ] || (echo "Removing Avahi" && \
  rm -rf /etc/services.d/avahi \
    /etc/services.d/dbus \
    /etc/cont-init.d/40-dbus-avahi)