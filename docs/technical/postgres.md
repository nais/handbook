Postgres in nais-system
=======================

!!! warning "Experimental feature"
   Postgres provisioned by the Zalando postgres-operator, is an experimental feature for now.
   Requires that the [postgres-operator feature](https://fasit.nais.io/features/postgres-operator) is enabled in the cluster you are deploying to.

This documentation describes how to provision and use a PostgreSQL database using the postgres-operator for things running in nais-system.
The procedure is the same for management and tenant clusters.

## Creating the PostgreSQL database

As part of your feature, install a `postgresql` resource in the `pg-nais-system` namespace.
Remember to select suitable values for these fields:

- `.spec.volume.size`
- `.spec.numberOfInstances` (2 or 3 recommended)
- `.spec.resources`
- `.spec.postgresql.version`

```yaml title="postgresql.yaml"
---
apiVersion: "acid.zalan.do/v1"
kind: postgresql
metadata:
  name: {{ include "my_feature.name" . }}
  namespace: pg-{{ .Release.Namespace }}
  labels:
      {{- include "my_feature.labels" . | nindent 4 }}
    apiserver-access: enabled
spec:
  teamId: {{ .Release.Namespace }}
  volume:
    size: "5Gi"
    storageClass: "premium-rwo"
  numberOfInstances: 3
  patroni:
    synchronous_mode: true
    synchronous_mode_strict: true
  preparedDatabases:
    app:
      defaultUsers: true
      secretNamespace: {{ .Release.Namespace }}
      schemas:
        public: {}
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: nais.io/type
              operator: In
              values:
                - postgres
  resources:
    limits:
      memory: "2Gi"
    requests:
      cpu: "300m"
      memory: "2Gi"
  postgresql:
    version: "17"
```

## Configure the application to use the database

The postgres-operator will create a secret with username and password, but there are a number of other details you need to configure.
You must add these to the `spec.template.spec.containers[].env` section of your deployment:

The convention we have settled for is to use the environment variables supported by libpq (and many other postgres libraries), and variables named similarly:

```yaml title="deployment.yaml"
env:
   - name: PGHOST
     value: {{ include "my_feature.name" . }}.pg-{{ .Release.Namespace }}
   - name: PGPORT
     value: "5432"
   - name: PGDATABASE
     value: app
   - name: PGUSER
     valueFrom:
       secretKeyRef:
         key: username
         name: app-owner-user.{{ include "my_feature.name" . }}.credentials.postgresql.acid.zalan.do
   - name: PGPASSWORD
     valueFrom:
       secretKeyRef:
         key: password
         name: app-owner-user.{{ include "my_feature.name" . }}.credentials.postgresql.acid.zalan.do
   - name: PGURL
     value: postgresql://$(PGUSER):$(PGPASSWORD)@$(PGHOST):$(PGPORT)/$(PGDATABASE)
   - name: PGJDBCURL
     value: jdbc:postgresql://$(PGHOST):$(PGPORT)/$(PGDATABASE)?user=$(PGUSER)&password=$(PGPASSWORD)
```

In addition to the environment variables, you must also label your pods with `postgres=true` to allow the network policies to work correctly.

## Network policies

The postgres-operator feature will by default install a set of network policies in the `nais-system` and `pg-nais-system` namespaces that will allow network access.
To make the experience slightly better for nais developers, we have made the policies more permissive than the ones we create for tenant applications.
The policies are designed such that all pods with the label `postgres=true` in the `nais-system` namespace will have access to any postgres database in the `pg-nais-system` namespace.

For tenant applications, network policies are tailored for each individual application.

## Connection pooler

For the majority of applications in the `nais-system` namespace, we have assumed that a separate connection pooler is not needed.
Should the need arise, the postgresql resource can be configured with a connection pooler configuration, and the `PGHOST` variable needs to be adjusted to point to the connection pooler pods instead of the postgres cluster directly.

```yaml title="postgresql.yaml"
spec:
   enableConnectionPooler: true
   connectionPooler:
     resources:
       requests:
         cpu: "50m"
         memory: "50Mi"
```

```yaml title="deployment.yaml"
env:
   - name: PGHOST
     value: {{ include "my_feature.name" . }}-pooler.pg-{{ .Release.Namespace }}
```