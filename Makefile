export PREFIX=docker-machine-driver-kvm
export GO_VERSION ?= 1.8.1
export MACHINE_VERSION ?= v0.10.0
export GIT_ROOT=$(shell git rev-parse --show-toplevel)
DESCRIBE=$(shell git describe --tags)

TARGETS=$(addprefix out/$(PREFIX)-, alpine3.4 alpine3.5 ubuntu14.04 ubuntu16.04 centos7 opensuse42.2)

build: $(TARGETS)

$(PREFIX)-base\:%: dockerfiles/Dockerfile.%
	"$(GIT_ROOT)/make/base" $@

Dockerfile.%.build:
	@echo "FROM $(PREFIX)-base:$*" >> $@
	@echo "ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin:/go/bin" >> $@
	@echo "ENV GOPATH /go" >> $@
	@echo "COPY . /go/src/github.com/dhiltgen/docker-machine-kvm" >> $@

out/$(PREFIX)-%: $(PREFIX)-base\:% Dockerfile.%.build
	"$(GIT_ROOT)/make/build" $<

clean:
	rm -f ./out/$(PREFIX)-*

clean-bases:
	docker rmi $(docker images -q $(PREFIX)-base)

release: build
	@echo "Paste the following into the release page on github and upload the binaries..."
	@echo ""
	@for bin in out/$(PREFIX)-* ; do \
	    bin=$$(basename "$$bin"); \
	    target=$$(echo $${bin} | cut -f5- -d-) ; \
	    md5=$$(md5sum out/$${bin}) ; \
	    echo "* $${target} - md5: $${md5}" ; \
	    echo '```' ; \
	    echo "  curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/$(DESCRIBE)/$${bin} > /usr/local/bin/$(PREFIX)" ; \
	    echo "  chmod +x /usr/local/bin/$(PREFIX)" ; \
	    echo '```' ; \
	done

