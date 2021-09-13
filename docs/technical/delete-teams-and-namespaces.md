# How to delete a team and it's namespaces/resources in the GCP/Github world

Ref. https://doc.nais.io/basics/teams/ - at the time of this writing - this list should reflect the moving parts one needs to manually delete:

1. Delete team from [navikt/teams](https://github.com/navikt/teams/blob/master/teams.yml).
	1. Remember to manually approve PR (by writing `/approve`, like so: https://github.com/nais/teams/pull/144#issuecomment-917988844]) in [nais/teams](https://github.com/nais/teams) - this is by design to avoid accidental deletions.
	!!! warning
		The automation creating this PR can take some time, wait ~30-60 minutes.
		_**DO NOT MERGE MANUALLY, ONLY WRITE `/approve` AS MENTIONED ABOVE**_
1. Delete team from https://mygroups.microsoft.com/
1. Delete team from https://github.com/orgs/navikt/teams
1. Delete team secrets from deploy.nais.io (TBD/TODO)
