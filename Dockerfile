FROM resin/rpi-node:latest
MAINTAINER Glavin Wiecher <glavin.wiechert@gmail.com>

# Defines our working directory in container
WORKDIR /usr/src/app

# Install more dependencies
RUN apt-get update
RUN apt-get install -y curl wget git python build-essential make g++ libavahi-compat-libdnssd-dev libkrb5-dev vim net-tools

# Install homebridge
RUN npm install -g homebridge --unsafe-perm

# Copies the package.json first for better cache on later pushes
COPY package.json package.json

# This install npm dependencies on the resin.io build server,
# making sure to clean up the artifacts it creates in order to reduce the image size.
RUN JOBS=MAX npm install --production --unsafe-perm && npm cache clean && rm -rf /tmp/*

# This will copy all files in our root to the working directory in the container
COPY . ./

# Enable systemd init system in container
ENV INITSYSTEM on

# server.js will run when container starts up on the device
CMD ["npm", "start"]
