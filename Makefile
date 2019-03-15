PREFIX=docker-machine-driver-kvm
MACHINE_VERSION=v0.10.0
GO_VERSION=1.8.1
DESCRIBE=$(shell git describe --tags)
ORIGIN=$(shell git remote -v | grep '(push)$$' | sed -e 's!\S\S*\s\s*\(\S\S*\)\s.*!\1!')
REPOSITORY=$(shell echo '$(ORIGIN)' | sed -e 's!\(https://\|\S\S*@\)\([^/:][^/:]*\)[/:]\(.*\)\.git$$!https://\2/\3!')

TARGETS=$(addprefix $(PREFIX)-, alpine3.4 alpine3.5 ubuntu14.04 ubuntu16.04 centos7)

build: $(TARGETS)

$(PREFIX)-%: Dockerfile.%
	docker rmi -f $@ >/dev/null  2>&1 || true
	docker rm -f $@-extract > /dev/null 2>&1 || true
	echo "Building binaries for $@"
	docker build --build-arg "MACHINE_VERSION=$(MACHINE_VERSION)" --build-arg "GO_VERSION=$(GO_VERSION)" -t $@ -f $< .
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
	    md5=$$(md5sum $${bin} | cut -f1 -d' ') ; \
	    sha256=$$(sha256sum $${bin} | cut -f1 -d' ') ; \
	    echo "#### $${target}" ; \
	    echo "$${bin}" ; \
	    echo "* SHA-256: $${sha256}" ; \
	    echo "* MD5: $${md5}" ; \
	    echo '```' ; \
	    echo "curl -L $(REPOSITORY)/releases/download/$(DESCRIBE)/$${bin} > /usr/local/bin/$(PREFIX) && \\"; \
	    echo "chmod +x /usr/local/bin/$(PREFIX)" ; \
	    echo '```' ; \
	done

