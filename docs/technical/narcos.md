# Narcos

Nais Adminstrator CLI Og Scripts

## Installation

`brew install narc`

## Usage

See available subcommands under the Reference section in the navigation sidebar.

### kubeconfig command

Create a kubeconfig file for connecting to available kubeconfigs for you.
This requires that you have the gcloud command line tool installed, configured and logged in.
You can log in with `gcloud auth login --update-adc`.

```bash
narc --help kubeconfig
```
gives

| Flag      | Short | Description                                                      |
|-----------|-------|------------------------------------------------------------------|
| overwrite | -o    | Will overwrite users, clusters, and contexts in your kubeconfig. |
| clear     | -c    | Clear existing kubeconfig before writing new data                |
| verbose   | -v    | More output, mostly useful combined with overwrite               |


### tenant command

The `tenant` command let you `list`, `get`, and `set` tenant for your Naisdevice.

#### list

List tenants available.

```bash
narc tenant list
```

#### get

Get your current tenant.

```bash
narc tenant get
```

#### set

Switches your tenant to the one specified.
May require that you log in.

```bash
narc tenant set TENANT
```
