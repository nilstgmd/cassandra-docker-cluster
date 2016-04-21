TAG ?= "meder/cassandra_cluster:latest"
DOCKER ?= docker

.DEFAULT_GOAL: run
run:
	@sh ./scripts/cassandraDockerCluster.sh

build:
	@$(DOCKER) build -t $(TAG) --rm=true .
	@$(DOCKER) pull abh1nav/opscenter:latest

clean:
	@$(DOCKER) ps -a -q --filter ancestor=$(TAG) --format="{{.ID}}" | xargs $(DOCKER) stop | xargs $(DOCKER) rm
	@$(DOCKER) ps -a -q --filter ancestor=abh1nav/opscenter --format="{{.ID}}" | xargs $(DOCKER) stop | xargs $(DOCKER) rm

.PHONY: clean run
