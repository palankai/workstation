# Secretless Idempotent MacOS setup with Ansible

Migration from a different repository is ongoing.

This repository contains my MacOS configuration.
Most of the steps are automated. The script might ask for sudo password.
There are some manual steps, after the installations.
Goal is not to fully automate, but ensure the smoothest possible start on a new 
installation.

It also helps me to keep more or less the same environment both on my personal and work 
machine, which helps me to reduce the context switching.

I don't recommend to use it as it is. Get inspired, copy part of it.

I spend about 2-3 years to get to this stage, I only install apps and tools
that I need.

This repository is kept up-to-date with my current needs, sometimes includes workarounds.
I update them if necessary, if I find an obsticle.

The repository doesn't contain any secrets.

## Full setup steps

### 0. Insert Yubikey

### 1. Initialise the machine

Idempotent, but needed only once.

Download and execute the `initial-setup.sh` file.
That script does the following:
- Environment setup, so my machine setups can be slightly different
- Install requirements: homebrew, ansible and gpg
- setup gpg & ssh
- Clone the repository

### 2. Start the setup process

This can and should be repeated frequently

In the `~/opt/workstation` exectue:

```
make
```

### 3. Manual steps

These steps needs to be done mostly once

