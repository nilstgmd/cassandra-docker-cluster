#!/bin/bash
#
# A script to setup a Cassandra cluster running in Docker containers.
#
# Per default there will be 3 nodes in the cluster and one container
# running OpsCenter.
#
# Usage (The "-n=4" option is added to start 4 nodes):
#   ./cassandraDockerCluster.sh -n=4
# Author:
#   Nils Meder

for i in "$@"
do
case $i in
    -n=*|--number=*)
    NUMBER="${i#*=}"
    ;;
    *)
    ;;
esac
done

if [ -z "$NUMBER" ]; then
	NUMBER=3
    echo "No cluster size defined. Using default of 3 nodes."
fi

echo "Starting cassandra cluster with $NUMBER nodes"

# Start OpsCenter
echo "Starting OpCenter"
docker run -d --name cassandra_oc -p 8888:8888 -p 61620:61620 meder/cassandra_opscenter:latest

sleep 10
OPS_IP=$(docker inspect --format '{{ (index (index .NetworkSettings.Ports "8888/tcp") 0).HostIp }}' cassandra_oc)

# Start the first node.
TOKEN=$(python -c 'print str(((2**64 / 3) * 1) - 2**63)')
echo "Starting node cassandra_c1 ($TOKEN)"
docker run -d -v /var/lib/cassandra/c1:/var/lib/cassandra -e CASSANDRA_TOKEN=$TOKEN -e OPS_IP=$OPS_IP --name cassandra_c1 meder/cassandra_cluster:latest
sleep 10

# Get the ip of the first node.
SEED_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' cassandra_c1)

if [ "$NUMBER" -ne 1 ]; then
	# Start the next nodes with their tokens and the seed.
	for i in $(seq 2 $NUMBER); do
  		NAME=cassandra_c$i
  		TOKEN=$(python -c 'print str(((2**64 / 3) * '$i') - 2**63)')
  		echo "Starting node $NAME ($TOKEN)"
  		docker run -d -v /var/lib/cassandra/c$i:/var/lib/cassandra -e CASSANDRA_TOKEN=$TOKEN -e CASSANDRA_SEEDS=$SEED_IP -e OPS_IP=$OPS_IP --name $NAME meder/cassandra_cluster:latest
  		sleep 10
	done
fi

echo "Registering cluster with OpsCenter"
curl -sS -X POST -d "{\"cassandra\": {\"seed_hosts\": \"$SEED_IP\"}, \"cassandra_metrics\": {}, \"jmx\": {\"port\": \"7199\"}}" http://$OPS_IP:8888/cluster-configs > /dev/null
echo "Access OpsCenter under http://$OPS_IP:8888/"
