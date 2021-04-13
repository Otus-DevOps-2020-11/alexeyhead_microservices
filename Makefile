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
