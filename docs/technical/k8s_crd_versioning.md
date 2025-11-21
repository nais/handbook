# K8s CRD Versioning

Updating a CRD in Kubernetes involves adding a new version to the CRD, and then [doing a "dance"](#so-what-are-the-general-steps-to-follow), which [that many often skip](https://blog.howardjohn.info/posts/crd-versioning/#removing-versions-and-changing-storage-version).

## Just give me a damn nais-specific checklist
1. Add new CRD version + `conversion webhook` config to liberator/`nais-crds`'s fasit-feature
    - !!![DON'T DEPLOY](https://nav-it.slack.com/archives/C050DP53VPH/p1763636578685559)!!!
1. Turn off reconciliation in `fasit` for all envs/tenants for `nais-crds`
    - Except where you want to test/iterate in solitude
1. Now you can deploy `nais-crds`, ref step 1.
1. When happy, deploy to all envs/tenants
    - _without_ having changed which CRD version has `storage == true`
1. Update all clients that leverage this CRD to use the new version, eg:
    - operators
    - controllers
    - tools generating k8s yamls that get `kubectl apply`ed
1. Set `storage == true` to the new version
    - Remember to update the `conversion webhook` if necessary, ref [the notes on `conversion webhook`](#so-how-does-this-relate-to-a-conversion-webhook)s
1. Set `served == false` for the old version(s), and/or delete them from the CRD
1. If other versions (besides the one that has `served == true && storage == true` have been removed
    - You can now delete the `conversion webhook` and its config.
1. Remember to clean up all solutions that support the old/removed versions from step 5.

## What would you need to know about K8s CRD Versions?
1. Each version has these two fields:
    1. `served` (boolean): whether or not this version is served by the API server (e.g. accessible for k8s clients)
    1. `storage` (boolean): if this version is how CRD (across all versions) are stored in etcd
        - There has to be x1 of these set to `true`, and only x1.
          All other versions have to have this field set to `false`.
1. Thus, the CRD versions follow a[^1]
    - `hub` (the version with `storage` set to `true`) and
    - `spoke`s (all versions with `served` set to `true`) model

## So how does this relate to a `conversion webhook`?
When using the https://kubebuilder.io controller-runtime, which we leverage in the NAIS platform's [liberator](https://github.com/nais/liberator), a `conversion webhook`[^2] will/must:

1. always convert _from_ the `storage == true` version
1. be able to convert _to_ **any** of the `served == true` versions

## So, what are the general steps to follow?
1. Design/spec out the new CRD version
1. Write the conversion webhook that satisfies the list in [how does this relate to a `conversion webhook`?](#so-how-does-this-relate-to-a-conversion-webhook)
1. Install to the cluster/add a new version to the CRD + the required `spec.conversion` field which configures the [conversion webhook](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definition-versioning/#configure-customresourcedefinition-to-use-conversion-webhooks)
1. Verify that you can `kubectl get <resource kind>.<new resource version>.<resource apiVersion without the '/<version>'>` for your custom resorces
1. Update all clients leveraging this CRD to make use of/reference `apiVersion` of this CRD with the new version
1. Update the CRD to set `storage == true` from the old version that had this, to the new version
    1. Remember to also update `conversion webhook` now, if necessary
1. If you don't want to remove the old version(s), you can stop now.
    - If you want to remove the old version(s), proceed with the remaining steps
1. Update the CRD to have `served == false` for all versions you want to remove
1. Use the prometheus metric `apiserver_storage_objects` to ensure all of the resources are stored in the new `storage == true` version[^3]
1. Delete the version(s) you want to remove from the CRD
    1. If there's only 1x version of the CRD left, you can delete the `conversion webhook` and its config too
    1. Remember to delete any code/implementations that handle multiple versions from step 6.

[^1]: https://book.kubebuilder.io/multiversion-tutorial/conversion-concepts
[^2]: https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definition-versioning
[^3]: https://dev.to/jotak/kubernetes-crd-the-versioning-joy-6g0
