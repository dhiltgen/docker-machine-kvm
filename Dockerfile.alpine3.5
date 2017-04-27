FROM alpine:3.5

MAINTAINER Daniel Hiltgen <daniel.hiltgen@docker.com>

ARG MACHINE_VERSION
ENV GOPATH /go

RUN apk -v add --update libvirt-dev curl go git musl-dev gcc
RUN git clone --branch ${MACHINE_VERSION} https://github.com/docker/machine.git /go/src/github.com/docker/machine

COPY . /go/src/github.com/dhiltgen/docker-machine-kvm
WORKDIR /go/src/github.com/dhiltgen/docker-machine-kvm
RUN go get -v -d ./...

RUN go install -v ./cmd/docker-machine-driver-kvm
