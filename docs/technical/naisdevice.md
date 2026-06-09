# Naisdevice (Nav)

## Access management

Nav employees who automatically get access to Naisdevice belong to the AD groups `Utviklere i Data (interne)`, `Utviklere i IT utvikling (eksterne)`, and `Utviklere i IT utvikling (interne)`.
If you are not in one of these three groups, you must be manually added to the Azure Enterprise Applications `Naisdevice` and `Naisdevice JITA`.
We have stopped adding users one by one, and instead let the tech lead per team take on this responsibility.

Steps:

1. Ask the tech lead to create an AD group via [mygroups.microsoft.com](https://mygroups.microsoft.com/)
    - They set themselves as owner and only add the members who need access to Naisdevice (no need to add those who already get it through the groups mentioned above)
    - Group name: `teamname-naisdevice`
    - Description: `Access to naisdevice for team members not employed in development and data`
2. Add the new group to [`Kolide (app.kolide.com)`][1], [`Naisdevice agent`][2], and [`Naisdevice JITA`][3]


## ADR

You can find the Naisdevice ADR at [ny-i-nav/naisdevice](https://navikt.github.io/ny-i-nav/naisdevice).

[1]: https://portal.azure.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Users/objectId/fe4e7138-6ef3-438b-870e-af2902420195/appId/aa8ba96c-657c-4b1f-8d09-327fc94b3c0a/preferredSingleSignOnMode/saml/servicePrincipalType/Application/fromNav/
[2]: https://portal.azure.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/be91f28a-0ef7-4da4-a55a-a8f9c9e71ad6/appId/8086d321-c6d3-4398-87da-0d54e3d93967/preferredSingleSignOnMode~/null/servicePrincipalType/Application/fromNav/
[3]: https://portal.azure.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/a0d18f34-1e10-4be1-acb8-71d66e3d9318/appId/8b625469-1988-4adf-b02f-115315596ab8/preferredSingleSignOnMode/saml/servicePrincipalType/Application/fromNav/
