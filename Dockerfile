FROM node:13.1.0

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# Install dependencies and tools
RUN apt-get update && apt-get upgrade -y; \
   apt-get install -y apt-utils apt-transport-https curl wget libnss-mdns avahi-discover libavahi-compat-libdnssd-dev libkrb5-dev ffmpeg nano \
   && mkdir /homebridge \
   && npm set global-style=true \
   && npm set package-lock=false

# Install latest Homebridge
RUN npm install -g homebridge@latest --unsafe-perm
RUN npm install -g homebridge-config-ui-x@latest --unsafe-perm

WORKDIR /homebridge
VOLUME /homebridge

# MISC settings
COPY avahi-daemon.conf /etc/avahi/avahi-daemon.conf

USER root
RUN mkdir -p /var/run/dbus

ADD image/run.sh /root/run.sh

# Run container
EXPOSE 7070
EXPOSE 51826

#CMD ["/root/run.sh"]

CMD homebridge