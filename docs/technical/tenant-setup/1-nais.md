# Step 1 - Nais-team preparations

## Create the terraform service user

In [nais-terraform-modules](https://github.com/nais/nais-terraform-modules)

Add the new tenant to `serviceaccounts.tf`. 

The name you choose here will be the $NAIS_TENANT_ALIAS used in the next step.

Create a PR and let Atlantis plan and apply the changes.

## Add the new tenant to the Nais billing account

- Billing -> Account Management -> Right side menu -> Add user.

## Ask the tenant about what IP-ranges they want to use

Make sure we have IP-ranges that do not overlap with the tenant's existing infrastructure.
If the tenant requires connectivity with external 
### Example ranges
#### Clusters
##### Management
| Subnetworks    | Description       |
|----------------|-------------------|
| 10.0.0.0/26    | node ip range     |
| 10.0.8.0/21    | pod ip range      |
| 192.168.0.0/21 | services ip range |
| 100.64.4.0/24  | internal lb range |
| 172.16.5.0/28  | apiserver         |


##### sandbox
| Subnetworks    | Description       |
|----------------|-------------------|
| 10.0.2.0/23    | node ip range     |
| 10.0.64.0/18   | pod ip range      |
| 192.168.8.0/21 | services ip range |
| 100.64.5.0/24  | internal lb range |
| 172.16.5.16/28 | apiserver         |
| 172.16.5.16/24 | aiven             |

