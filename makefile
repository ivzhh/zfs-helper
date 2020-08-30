.PHONY: build run dep mod

.EXPORT_ALL_VARIABLES:

all: build

export GO111MODULE=on
export CGO_LDFLAGS_ALLOW=-Wl,-?-wrap[=,][^-.@][^,]*
export PREFIX := $(shell pwd)

ifeq (,$(wildcard ./go.patch.mod))
mod: go.mod

else
	export GOENV=./goenv

go.local.mod: go.mod go.patch.mod
	cat go.mod > go.local.mod
	[ -f go.patch.mod ] && cat go.patch.mod >> go.local.mod

mod: go.local.mod

endif

build: mod
	export GOENV CGO_LDFLAGS_ALLOW
	@echo $$GOENV $$CGO_LDFLAGS_ALLOW
	go build -o build/zfs-helper

run: install
	bin/zfs-helper

install: build
	sudo install -D -o 0 -g 0 -m u=sx,go=x build/zfs-helper $$PREFIX/bin/zfs-helper

