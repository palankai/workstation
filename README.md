# Secretless Idempotent macOS setup with Ansible

Migration from a different repository is ongoing.

This repository contains my macOS configuration.
Most of the steps are automated. The script might ask for sudo password.
There are some manual steps after the installations.
The goal is not to fully automate but ensure the smoothest possible start on a new
installation.

It also helps me to keep more or less the same environment both on my personal and work
machine, which helps me to reduce the context switching.

I don't recommend using it as it is. Get inspired, copy part of it.

I spend about 2-3 years to get to this stage, I only install apps and tools
that I need.

This repository is kept up-to-date with my current needs; it includes workarounds.
I update them if necessary when I find an obstacle.

The repository doesn't contain any secrets.

## Full setup steps

### 0. Insert Yubikey

### 1. Initialise the machine

Idempotent, but needed only once.

Download and execute the `initial-setup.sh` file.
Simplified install: `sh -c "$(curl -sSL https://raw.githubusercontent.com/palankai/workstation/master/initial-setup.sh)"`

That script does the following:
- Environment setup, so my machine setups can be slightly different
- Install requirements: homebrew, Ansible, and GPG
- setup GPG & ssh
- Clone the repository

### 2. Start the setup process

This can and should be repeated frequently

In the `~/opt/workstation` exectue:

```
make
```

### 3. Manual steps

Most of these steps need to be done once.

