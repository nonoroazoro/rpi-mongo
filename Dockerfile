#
# nonoroazoro/rpi-mongo Dockerfile.
#
# https://github.com/nonoroazoro/rpi-mongo
#

# Pull base image.
FROM resin/rpi-raspbian:jessie

# Add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added.
RUN groupadd -r mongodb && useradd -r -g mongodb mongodb

# Add proxy for apt-get.
ADD 10proxy /etc/apt/apt.conf.d/

# Install MongoDB & remove proxy.
RUN apt-get update \
    && apt-get install -y mongodb-server \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/mongodb \
    && rm -rf /etc/apt/apt.conf.d/10proxy

# Configuration.
RUN mkdir -p /data/db /data/configdb \
    && chown -R mongodb:mongodb /data/db /data/configdb

# Define mountable directories.
VOLUME /data/db /data/configdb

# Define working directory.
WORKDIR /data

# Expose ports.
# 	- 27017: process
#   - 28017: http
EXPOSE 27017
EXPOSE 28017

# Define default command.
CMD ["mongod"]
