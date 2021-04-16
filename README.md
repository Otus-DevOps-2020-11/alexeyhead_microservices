# alexeyhead_microservices
alexeyhead microservices repository

### HW No. 16 (Lecture No. 22)

- The practical task of the methodical manual is performed
- Added `mongodb-exporter` from `percona/mongodb_exporter`
- Added `blackbox-exporter` from official image `prom/blackbox-exporter`
- Added appropriate jobs for the Prometheus `config.yml`
    * After each change of the `config.yml` of Prometheus the image needs to be reconsidered
    
```
global:
  scrape_interval: '5s'

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets:
        - 'localhost:9090'

  - job_name: 'ui'
    static_configs:
      - targets:
        - 'ui:9292'

  - job_name: 'comment'
    static_configs:
      - targets:
        - 'comment:9292'

  - job_name: 'node'
    static_configs:
      - targets:
        - 'node-exporter:9100'

  - job_name: 'mongodb'
    static_configs:
      - targets:
        - 'mongodb-exporter:9216'

  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]
    static_configs:
      - targets:
        - http://ui:9292
        - http://comment:9292/healthcheck
        - http://post:5000/healthcheck
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackbox-exporter:9115

```

- Final version of the `docker-compose.yml`
  
```
version: '3.3'
services:
  post_db:
    image: mongo:3.2
    volumes:
      - post_db:/data/db
    networks:
      back_net:
        aliases:
          - comment_db
          - post_db

  ui:
#    build: ./ui
    image: ${USER_NAME}/ui:${UI_TAG}
    ports:
      - ${HOST_PORT}:${CONTAINER_PORT}/tcp
    networks:
      - front_net

  post:
#    build: ./post-py
    image: ${USER_NAME}/post:${POST_TAG}
    networks:
      - back_net
      - front_net

  comment:
#    build: ./comment
    image: ${USER_NAME}/comment:${COMMENT_TAG}
    networks:
      - back_net
      - front_net

  prometheus:
    image: ${USER_NAME}/prometheus
    ports:
    - '9090:9090'
    volumes:
    - prometheus_data:/prometheus
    command:
      - "--config.file=/etc/prometheus/prometheus.yml"
      - "--storage.tsdb.path=/prometheus"
      - "--storage.tsdb.retention=1d"
    networks:
      - back_net
      - front_net

  node-exporter:
    image: prom/node-exporter:v0.15.2
    user: root
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.ignored-mount-points="^/(sys|proc|dev|host|etc)($$|/)"'
    networks:
      - back_net
      - front_net

  mongodb-exporter:
#    image: bitnami/mongodb-exporter
    image: ${USER_NAME}/mongodb-exporter
    networks:
      - back_net
    command:
      - '--mongodb.uri=mongodb://post_db:27017'
    depends_on:
      - post_db

  blackbox-exporter:
    image: ${USER_NAME}/blackbox-exporter
    command:
      - '--config.file=/etc/blackboxexporter/config.yml'
    networks:
      - back_net
      - front_net

volumes:
  post_db:
  prometheus_data:

networks:
  back_net:
    driver: bridge
    ipam:
      config:
        - subnet: ${BACK_NET_SUBNET}
  front_net:
    driver: bridge
    ipam:
      config:
        - subnet: ${FRONT_NET_SUBNET}

```

- Created `Makefile` for automation build and push all and separate docker's images
```
USER_NAME=oleksiihead

docker-login:
	docker loging -u $(USER_NAME)

# Build docker images
build-all: build-ui build-post build-comment build-prometheus build-mongodb-exporter build-blackbox-exporter

build-ui:
	cd src/ui && \
	USER_NAME=$(USER_NAME) bash docker_build.sh

build-post:
	cd src/post-py && \
	USER_NAME=$(USER_NAME) bash docker_build.sh

build-comment:
	cd src/comment && \
	USER_NAME=$(USER_NAME) bash docker_build.sh

build-prometheus:
	docker build -t $(USER_NAME)/prometheus monitoring/prometheus

build-mongodb-exporter:
	docker build -t $(USER_NAME)/mongodb-exporter monitoring/exporters/mongodb-exporter

build-blackbox-exporter:
	docker build -t $(USER_NAME)/blackbox-exporter monitoring/exporters/blackbox-exporter

push-all: push-ui push-post push-comment push-prometheus push-mongodb-exporter push-blackbox-exporter

push-ui:
	docker push $(USER_NAME)/ui

push-post:
	docker push $(USER_NAME)/post

push-comment:
	docker push $(USER_NAME)/comment

push-prometheus:
	docker push $(USER_NAME)/prometheus

push-mongodb-exporter:
	docker push $(USER_NAME)/mongodb-exporter

push-blackbox-exporter:
	docker push $(USER_NAME)/blackbox-exporter

Links on DockerHub
https://hub.docker.com/repository/docker/oleksiihead/ui
https://hub.docker.com/repository/docker/oleksiihead/post
https://hub.docker.com/repository/docker/oleksiihead/comment
https://hub.docker.com/repository/docker/oleksiihead/prometheus
https://hub.docker.com/repository/docker/oleksiihead/mongodb-exporter
https://hub.docker.com/repository/docker/oleksiihead/blackbox-exporter
