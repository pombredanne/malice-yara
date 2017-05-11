REPO=malice
NAME=yara
VERSION=$(shell cat VERSION)

all: build size test

build:
	docker build -t $(REPO)/$(NAME):$(VERSION) .

size:
	sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell docker images --format "{{.Size}}" $(REPO)/$(NAME):$(VERSION)| cut -d' ' -f1)%20MB-blue/' README.md


test:
	docker run --rm $(REPO)/$(NAME):$(VERSION) --help
	docker run --rm $(REPO)/$(NAME):$(VERSION) -V /bin/sh > results.json
	cat results.json | jq .
	cat results.json | jq -r .$(NAME).markdown

.PHONY: build size tags test
