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
2. Legg den nye gruppen til i [`Naisdevice`][1], og [`Naisdevice JITA`][2]


## ADR

Du finner Naisdevice sin ADR under [ny-i-nav/naisdevice](https://navikt.github.io/ny-i-nav/naisdevice).

[1]: https://portal.azure.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/c395148c-2640-4ebc-a0db-c452c655bae1/appId/48621005-2663-4d05-ad8b-8e4abfeefb1d/preferredSingleSignOnMode/saml/servicePrincipalType/Application/fromNav/
[2]: https://portal.azure.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/a0d18f34-1e10-4be1-acb8-71d66e3d9318/appId/8b625469-1988-4adf-b02f-115315596ab8/preferredSingleSignOnMode/saml/servicePrincipalType/Application/fromNav/
