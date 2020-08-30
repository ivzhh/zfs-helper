.PHONY: build run dep

export GO111MODULE=on
export CGO_LDFLAGS_ALLOW="-Wl,-?-wrap[=,][^-.@][^,]*"

ifneq (,$(wildcard ./goenv))
	export GOENV=./goenv
endif

build:
	export GOENV
	go build -o build/zfs-helper

run: build
	build/zfs-helper

dep:
	export GO111MODULE CGO_LDFLAGS_ALLOW
	go mod tidy
