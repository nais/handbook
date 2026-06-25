# Initial setup

Forhåpentligvis så må ikke dette gjøres flere ganger, men nedenfor står det litt om hva som skal gjøres om man skal sette opp Nais på nytt.

## Github Runner

Vi har en Github Runner som brukes ved deploy av alle Fasit Features, og for oppsett av Atlantis.

Lag en VM instans i riktig prosjekt (sannsynligvis `nais-io`), og kall den gjerne `github-runner-nais-org`, og gi den 100GB boot disk.
10GB disk er for lite.

Den trenger også nettverk, og sannynligvis finnes det `network: nais-vpc` og `subnetwork: nais-subnetwork`.

For å sette den opp som Github runner er det best å følge Github sin egen oppskrift.
Gå til [nais/settings](https://github.com/organizations/nais/settings/actions/runners) og trykk på `New runner/New self-hosted runner`.
Velg `Linux` og følg oppskriften der.
Ikke legg den i din egen hjemmekatalog.
Husk også å starte den som en service med `./svc.sh install` og `sudo ./svc.sh start`.
Les mer om det på [docs.github.com](https://docs.github.com/en/actions/how-tos/manage-runners/self-hosted-runners/configure-the-application).

Når alt dette er gjort må du huske å legge til merkelappen `fasit-deploy`, for er det vi bruker som `runs-on` i Github workflows.

Vi har et gammelt oppsett for en Github Runner, hvis man er nysgjerrig.

- Terraform: https://github.com/nais/nais-io-terraform-modules/blob/dc8344f36fee5fdd21d22745ab95b83acbed0463/modules/base/github_runner.tf
- Startup-script: https://github.com/nais/nais-io-terraform-modules/blob/8d7ed3eafa162c73956b82bf8dc965fb5c9da360/scripts/startup.sh


## Atlantis

Det er et eget repo for å sette opp Atlantis, se [nais/atlantis-opentofu](https://github.com/nais/atlantis-opentofu).
Enklest å kjøre ut Atlantis etter man har satt opp en Github Runner.
