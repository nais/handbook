# cluster command

The `cluster` command let you generate `kubeconfig`, and `list` clusters available for you.

## kubeconfig

Create a kubeconfig file for connecting to available clusters for you.
This requires that you have the gcloud command line tool installed, configured and logged in.
You can log in with `gcloud auth login --update-adc`.

```bash
narc kubeconfig
```

| Flag      | Short | Description                                        |
|-----------|-------|----------------------------------------------------|
| overwrite |       | Overwrite config already in the kubeconfig-file    |
| clean     |       | Delete config before retrieving new one            |
| verbose   | -v    | More output, mostly useful combined with overwrite |

## list

List clusters available.

```bash
narc cluster list
```

