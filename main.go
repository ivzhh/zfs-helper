package main

import (
	"log"
	"syscall"

	zfs "github.com/bicomsystems/go-libzfs"
	// libcap "kernel.org/pub/linux/libs/security/libcap/cap"
	libpsx "kernel.org/pub/linux/libs/security/libcap/psx"
)

func main() {
	var ds zfs.Dataset
	var err error

	dsPath := "dpool/test1"

	if ds, err = zfs.DatasetOpen(dsPath); err != nil {
		log.Fatalf("fail to open dataset %s: %s", dsPath, err)
	}

	var props zfs.Property

	if props, err = ds.GetProperty(zfs.DatasetPropMountpoint); err != nil {
		log.Fatalf("fail to get property from dataset %s: %s", dsPath, err)
	}

	log.Printf("mountpoint: %s=%s", props.Source, props.Value)

	if _, _, err := libpsx.Syscall3(syscall.SYS_SETGID, uintptr(1000), 0, 0); err != 0 {
		log.Fatalf("failed to setgid(%d): %v", 1000, err)
	}
}
