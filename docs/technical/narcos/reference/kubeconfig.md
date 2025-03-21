# kubeconfig command

Create a kubeconfig file for connecting to available kubeconfigs for you.
This requires that you have the gcloud command line tool installed, configured and logged in.
You can log in with `gcloud auth login --update-adc`.

```bash
narc --help kubeconfig
```
gives

| Flag      | Short | Description                                                         |
|-----------|-------|---------------------------------------------------------------------|
| overwrite | -o    | Will overwrite users, clusters, and contexts in your kubeconfig.    |
| clear     | -c    | Clear existing kubeconfig before writing new data            |
| verbose   | -v    | More output, mostly useful combined with overwrite |
