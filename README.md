# cassandra-docker-cluster
This repository contains tooling for running a Cassandra Cluster including OpsCenter in a Docker environment.

## Quick Start

```sh
make all
```
By default 3 C* nodes will be started. In the output of the `make` you will find the URL where you can reach OpsCenter. The setup was tested with Docker for Mac (beta), you might need to adjust the `cassandraDockerCluster.sh` if you are using `boot2docker` or `docker-machine`.
