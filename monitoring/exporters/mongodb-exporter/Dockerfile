FROM golang:1.14

WORKDIR /go/src/github.com/percona/mongodb_exporter

RUN wget https://github.com/percona/mongodb_exporter/archive/v0.20.2.tar.gz && \
    tar xvzf v0.20.2.tar.gz && \
    cp -a mongodb_exporter-0.20.2/. /go/src/github.com/percona/mongodb_exporter

RUN make build

FROM ubuntu:20.04

COPY --from=0 /go/src/github.com/percona/mongodb_exporter/mongodb_exporter /bin/mongodb_exporter

RUN /bin/mongodb_exporter --version

EXPOSE 9216

ENTRYPOINT [ "/bin/mongodb_exporter" ]
