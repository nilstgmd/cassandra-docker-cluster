#!/bin/bash
if [ -z $OPS_IP ]; then
	echo "No OPS_IP provided, agent won't start"
	tail -f /dev/null
else
	echo "OpsCenter IP is: $OPS_IP"
	if [ ! -f /root/.agentconfig ]; then
		echo "Filling in the blanks inside address.yaml"
		cd /opt/agent/conf
		echo "stomp_interface: $OPS_IP" >> ./address.yaml
		touch /root/.agentconfig
	fi

	echo "Sleeping 10 sec. before starting agent"
	sleep 10
	nohup bash /opt/agent/bin/datastax-agent &
fi
sh /usr/local/bin/cassandra-clusternode
