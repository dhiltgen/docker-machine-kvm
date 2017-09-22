PREFIX=docker-machine-driver-kvm
MACHINE_VERSION=v0.10.0
GO_VERSION=1.8.1
DESCRIBE=$(shell git describe --tags)

TARGETS=$(addprefix $(PREFIX)-, alpine3.4 alpine3.5 ubuntu14.04 ubuntu16.04 centos7 debian9)

build: $(TARGETS)

$(PREFIX)-%: Dockerfile.%
	docker rmi -f $@ >/dev/null  2>&1 || true
	docker rm -f $@-extract > /dev/null 2>&1 || true
	echo "Building binaries for $@"
	docker build --build-arg "MACHINE_VERSION=$(MACHINE_VERSION)" --build-arg "GO_VERSION=$(GO_VERSION)" --build-arg "PLUGIN_VERSION=$(DESCRIBE)" -t $@ -f $< .
	docker create --name $@-extract $@ sh
	docker cp $@-extract:/go/bin/docker-machine-driver-kvm ./
	mv ./docker-machine-driver-kvm ./$@
	docker rm $@-extract || true
	docker rmi $@ || true

clean:
	rm -f ./$(PREFIX)-*


release: build
	@echo "Paste the following into the release page on github and upload the binaries..."
	@echo ""
	@for bin in $(PREFIX)-* ; do \
	    target=$$(echo $${bin} | cut -f5- -d-) ; \
	    md5=$$(md5sum $${bin}) ; \
	    echo "* $${target} - md5: $${md5}" ; \
	    echo '```' ; \
	    echo "  curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/$(DESCRIBE)/$${bin} > /usr/local/bin/$(PREFIX) \\ " ; \
	    echo "  chmod +x /usr/local/bin/$(PREFIX)" ; \
	    echo '```' ; \
	done

