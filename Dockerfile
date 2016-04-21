# vim:set ft=dockerfile:
FROM spotify/cassandra:cluster

RUN mkdir /opt/agent \
    && wget -O - http://downloads.datastax.com/community/datastax-agent-5.1.0.tar.gz | tar xzf - --strip-components=1 -C "/opt/agent"

COPY scripts/entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

# Start Cassandra
ENTRYPOINT ["/sbin/entrypoint.sh"]
