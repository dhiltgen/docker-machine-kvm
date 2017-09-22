package main

import (
	"github.com/dhiltgen/docker-machine-kvm"
	"github.com/docker/machine/libmachine/drivers/plugin"
	"flag"
	"fmt"
)

// Will be set using "-X" linker option during build
var goVersion = "undefined"
var machineVersion = "undefined"
var pluginVersion = "undefined"

func main() {
	versionPtr := flag.Bool("version", true, "print version number")
	flag.Parse()
	if  *versionPtr {
		fmt.Printf("go: %s\nmachine: %s\nplugin: %s\n", goVersion, machineVersion, pluginVersion)
	} else {
		plugin.RegisterDriver(kvm.NewDriver("default", "path"))
	}
}
