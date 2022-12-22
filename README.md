# Unifi Blueberry - Podman

An addon for Unifi Blueberry (more info coming soon!) that installs and manages [Podman](https://podman.io/).

## Installation

As Unifi Blueberry is not yet ready for prime time, the Podman addon can be installed manually.

_Note: this has only been tested on a UDM Pro running 2.4 so far. Please let me know how it goes on other consoles with Unifi OS 2.4 or greater._

### Requirements

* A Unifi console running Unifi OS 2.4 or later
* Shell access to your console

### Install

1. SSH in to your console
2. Add the Unifi Blueberry APT repo
```shell
echo "deb https://apt.unifiblueberry.io/ stretch main" > /etc/apt/sources.list.d/unifi-blueberry.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C320FD3D3BF10DA7415B29F700CCEE392D0CA761
```
2. Install the `unifi-blueberry-addon-podman` package
```shell
apt update
apt install unifi-blueberry-addon-podman
```

That's it! Podman is now installed. Try it out:
```shell
podman run --rm -it alpine echo Hello World!
```

#### Package Download

If you prefer to download and install without using the APT repo you can find the packages attached to the GitHub releases.

## FAQs

### Does Podman persist after reboots?

Yes, reboots do not interfere with the installation.

### Does Podman persist after Unifi OS updates?

Currently unknown. You may have to reinstall.

### Can I install Podman on Unifi OS 1.x?

No, due to the significant changes in Unifi OS 2.x, version OS 1.x will not be supported.

### There is a new version of Podman but no release here, can you update?

Yes, please open a ticket and I would be happy to publish a new release. This will be automated in the future.

### I get a warning saying "Failed to read current user namespace mappings"

I don't currently know exactly what this means or how we might fix it. So far it doesn't seem to impact running containers. This issue will be investigated in the future.


## Credits

Heavily inspired by the work done in [unifi-utlities](https://github.com/unifi-utilities/unifios-utilities). Big thanks to the maintainers there for supporting customizations fo our Unifi consoles for so long!
