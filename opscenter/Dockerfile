# vim:set ft=dockerfile:
FROM python:2.7.11
MAINTAINER Nils Meder <nilstgmd@gmx.de>

# Download and extract OpsCenter
RUN \
  mkdir -p /opt/opscenter; \
  wget -O - http://downloads.datastax.com/community/opscenter-5.2.4.tar.gz \
  | tar xzf - --strip-components=1 -C "/opt/opscenter";
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose ports
EXPOSE 8888

WORKDIR /opt/opscenter

CMD ["bin/opscenter", "-f"]
