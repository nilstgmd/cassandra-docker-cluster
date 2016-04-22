C_TAG ?= "meder/cassandra_cluster:latest"
OC_TAG ?= "meder/cassandra_opscenter:latest"
DOCKER ?= docker

.DEFAULT_GOAL: run

all: clean build run

run:
	@sh ./cassandraDockerCluster.sh

build: cluster opscenter

cluster:
	@$(DOCKER) build -t $(C_TAG) --rm=true cluster/.

opscenter:
	@$(DOCKER) build -t $(OC_TAG) --rm=true opscenter/.

clean:
	@$(DOCKER) ps -a -q --filter ancestor=$(C_TAG) --format="{{.ID}}" | xargs $(DOCKER) stop | xargs $(DOCKER) rm
	@$(DOCKER) ps -a -q --filter ancestor=$(OC_TAG) --format="{{.ID}}" | xargs $(DOCKER) stop | xargs $(DOCKER) rm

.PHONY: all cluster opscenter build clean run
