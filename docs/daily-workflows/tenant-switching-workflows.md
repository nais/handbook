# Typical workflow examples
Some examples of daily workflows for guiding unfamiliar Nais members
!!! Note
    A caveat right of the bat, is that it should be completely unproblematic to switch tenants in [`naisdevice`][naisdevice] and access some resource outside of k8s clusters, before switching back and continuing work with `kubectl` without touching [`narc`][narcos] or `gcloud`.

!!! Critical
    Read through [privileges](/docs/technical/privileges.md) and ensure to understand both what user identity you are logging with, as well as what you might want to avoid doing with it or can do in another/better way.

## Daily switching between tenants
Start the day off with:

1. Log in w/[naisdevice] on the tenant who's cluster you intend to connect to (or NAV tenant if you e.g. wanna check email/calendar)
1. Set your google project account to your `@nais.io` user: `gcloud config set account <account email>`
1. Log in w/your `@nais.io` user to `gcloud`: `gcloud auth login --update-adc <account email>`
    1. If not done so before, this is the time to install cluster configs w/[`narc`][narcos], see [`narc kubeconfig`](/docs/technical/narcos/reference/kubeconfig.md)
1. Most likely, at this point, you'd want to execute `narc jita grant admin` to allow your `@nais.io` user useful access to a tenants' k8s cluster
1. Ét voila! You should be able to `kubectx` to the cluster(s) of your (naisdevice) connected tenant, and `kubectl` away

!!!! Note
    At any point during tho workday you need to access another cluster, switch tenants in naisdevice, and repeat last step of above list.

## Testing out some new feature as a tenant's user
Typically this is often done in `dev-nais.io` tenant.

1. Get a user for said tenant
1. Repeat the [steps mentioned in this linked workflow example](#daily-switching-between-tenants), but replace the references to [`narc`][narcos] with the equivalent [`nais`][nais-cli] cli's commands.

!!! TODO

[naisdevice]: https://github.com/nais/device
[narcos]: https://github.com/nais/narcos
[nais-cli]: https://github.com/nais/cli\n\n\n
