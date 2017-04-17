FROM centos:7

MAINTAINER Daniel Hiltgen <daniel.hiltgen@docker.com>

ARG MACHINE_VERSION
ARG GO_VERSION
ENV GOPATH /go

RUN yum install -y libvirt-devel curl git gcc
RUN curl -sSL https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin:/go/bin
RUN git clone --branch ${MACHINE_VERSION} https://github.com/docker/machine.git /go/src/github.com/docker/machine

COPY . /go/src/github.com/dhiltgen/docker-machine-kvm
WORKDIR /go/src/github.com/dhiltgen/docker-machine-kvm
RUN go get -v -d ./...

RUN go install -v ./cmd/docker-machine-driver-kvm
