package config

import (
	"fmt"

	"github.com/docker/machine/libmachine/drivers"
)

const isoFilename = "boot2docker.iso"

type Config struct {
	*drivers.BaseDriver

	Memory         int
	DiskSize       int
	CPU            int
	Network        string
	PrivateNetwork string
	ISO            string
	Boot2DockerURL string
	CaCertPath     string
	PrivateKeyPath string
	DiskPath       string
	CacheMode      string
	IOMode         string
}

func (c *Config) SetConfigFromFlags(flags drivers.DriverOptions) error {
	c.Memory = flags.Int("kvm-memory")
	c.DiskSize = flags.Int("kvm-disk-size")
	c.CPU = flags.Int("kvm-cpu-count")
	c.Network = flags.String("kvm-network")
	c.Boot2DockerURL = flags.String("kvm-boot2docker-url")
	c.CacheMode = flags.String("kvm-cache-mode")
	c.IOMode = flags.String("kvm-io-mode")

	c.SwarmMaster = flags.Bool("swarm-master")
	c.SwarmHost = flags.String("swarm-host")
	c.SwarmDiscovery = flags.String("swarm-discovery")
	c.ISO = c.ResolveStorePath(isoFilename)
	c.SSHUser = flags.String("kvm-ssh-user")
	c.SSHPort = 22
	c.DiskPath = c.ResolveStorePath(fmt.Sprintf("%s.img", c.MachineName))
	return nil
}
