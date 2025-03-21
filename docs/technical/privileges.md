# Privilegier og brukere

## nais-io-bruker
For å administrere Nais benyttes nais-io-brukeren din hos alle tenants.
Denne brukeren har i utgangspunktet svært få rettigheter, men man kan elevere tilgangene sine ved behov med [narc](./narcos/README.md). Vær klar over at `reason`-feltet i `narc`-kommandoene er obligatorisk, og at det er viktig å begrunne hvorfor du trenger tilgang til en spesifikk ressurs, da dette blir loggført og er synlig for tenants.
Med eleverte tilganger har du utvidet rettighetene dine i en begrenset periode i nais-katalogen hos den enkelte tenant.

## tenant-bruker
Noen ganger har vi behov for å teste hvordan funksjonaliteten vi har laget oppleves for utviklere på nais.
Til dette har vi dedikerte brukere i noen av tenantene. Eksempelvis dev-nais-brukere i dev-nais-tenanten.
Med denne brukeren kan du utforske console, opprette team og bruke plattformen som en vanlig utvikler.
Disse brukerne opprettes manuelt av noen med admin-tilgang til tenanten.

## Superadmin
I tillegg til å være Nais-administratorer har vi også ansvar for Navs GCP-organisasjon.
Dette krever tilganger ut over nais-katalogen, og det er en håndfull personer i nais-teamet som har personlige upersonlige brukere sikret med fysisk nøkkel som har mulighet til å gjøre ting på organisasjonsnivå.
