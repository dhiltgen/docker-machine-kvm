// +build !linux !cgo

package kvm

import "github.com/docker/machine/libmachine/drivers"

type Driver struct {
	*drivers.DriverNotSupported

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
}

func NewDriver(hostName, storePath string) *Driver {
	return &Driver{
		DriverNotSupported: drivers.NewDriverNotSupported("kvm", hostName, storePath).(*drivers.DriverNotSupported),
	}
}
