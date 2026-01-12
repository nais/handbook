# Naisdevice (Nav)

## Tilgangsstyring

De ansatte i Nav som får automatisk tilgang til Naisdevice tilhører AD-gruppen `Utviklere i Data (interne)`, `Utviklere i IT utvikling (eksterne)`, og `Utviklere i IT utvikling (interne)`.
Er man ikke i en av disse tre gruppene må man manuelt legges til Azure Enterprise Application `Naisdevice`, og `Naisdevice JITA`.
Vi har sluttet å legge en og en bruker inn, og lar heller tech lead per team få dette ansvaret.

Fremgangsmåte:

1. Be tech lead opprette en AD gruppe via [mygroups.microsoft.com](https://mygroups.microsoft.com/)
    - De setter seg selv som eier, og legger kun til de medlemmene som trenger tilgang til Naisdevice (trenger ikke legge til de som får det via gruppene nevnt ovenfor)
    - Gruppenavn: `teamnavn-naisdevice`
    - Beskrivelse: `Tilgang til naisdevice for teammedlemmer som ikke er ansatt i utvikling og data`
2. Legg den nye gruppen til i [`Naisdevice agent`][1], og [`Naisdevice JITA`][2]


## ADR

Du finner Naisdevice sin ADR under [ny-i-nav/naisdevice](https://navikt.github.io/ny-i-nav/naisdevice).

[1]: https://portal.azure.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/be91f28a-0ef7-4da4-a55a-a8f9c9e71ad6/appId/8086d321-c6d3-4398-87da-0d54e3d93967/preferredSingleSignOnMode~/null/servicePrincipalType/Application/fromNav/
[2]: https://portal.azure.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/a0d18f34-1e10-4be1-acb8-71d66e3d9318/appId/8b625469-1988-4adf-b02f-115315596ab8/preferredSingleSignOnMode/saml/servicePrincipalType/Application/fromNav/
