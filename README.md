# hello-saltstack
A small demo of SaltStack. It consists of a Vagrant environment with a Salt master and a minion.

Contents:
- salt/ - SaltStack configuration files
- service/ - Service files, such as configuration, systemd unit and Salt state file

## Dependencies
Yo will [Vagrant](https://www.vagrantup.com/) installed in order to spin up a local test environment. Also, install [Vagrant SCP plugin](https://github.com/invernizzi/vagrant-scp) which is used to copy files into the Vagrant boxes. You will also need [Docker](https://www.docker.com/) in order to compile the application, but on the other hand there is no need for a Go environment.

## Instructions
Run `make help` to get help or just:
1. Start the local test environment with `vagrant up`
2. Build the application using `make build`
3. Create a release (copy the application into the SaltStack master) with `make release`
4. Deploy to the minions using `make deploy`
5. Clean up with `make clean`

You can also just do `make all` to do it all in one go
