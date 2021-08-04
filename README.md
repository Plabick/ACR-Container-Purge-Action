# ACR Container Purge Action
## Description

An action to purge containers from the Azure Container Registry using the [ACR purge command](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-auto-purge). By default, the action purges containers from every repository in the ACR. You can run the purge on only one repo using the `repo` input, repos matching a regex using the `repo-regex` input, or all repos in your ACR by leaving both blank. The purge only applies to containers who's tag matches the `tag-regex` input and that are older then 'days-to-keep'.

## Inputs

| Parameter | Description | Required | Default |
| - | - | - | - |
| registry | The name of the Azure Container Registry to purge. Case insensitive i.e exampleazureregistry | `true` | N/A |
| username | Azure Service Principal Username | `true` | N/A |
| tenant | Azure Service Principal Tenant | `true` | N/A |
| password | Azure Service Principal Tennant ID | `true` | N/A |
| repo | The ACR repository to purge containers from. Leave blank to purge from all repositories | `false` | all |
| tag-regex | Only purge containers with tags matching this regex. Leave blank to purge containers with any tag | `false` | .* |
| repo-regex | Only purge containers from ACR repositories matching this regex. Only applicable if `repo` input is unset. Leave blank to purge containers from all repositories | `false` | .* |
| days-to-keep | Do not purge any containers younger than this | `false` | 7 |
| keep | Save this many containers from being purged that otherwise meet all other purge rules | `false` | 10 |

## Example Usage

```yaml
name: ACR Purge
on: 
    workflow_dispatch: 
    schedule:
       - cron: '0 06,18 * * *'
jobs:
  acr-purge:
    runs-on: ubuntu-latest
    env:
        registry: 'ExampleDockerHub' # Case insensitive ACR registry name
        regex-master: '^\d.\d.\d\d*$' 
        regex-feature: ".*-*"
        days-to-keep-master: "10"
        days-to-keep-feature: "1"
        keep-master: "50" 
        keep-feature: "5" 
        service-principal-username: ${{ secrets.SP_USERNAME }}
        service-principal-tenant: ${{ secrets.SP_TENANT }}
    steps:
    - name: Purge Feature Containers
      uses: Plabick/ACR-Container-Purge-Action@master
      with:
        registry: ${{ env.registry }}
        username: ${{ env.service-principal-username }}
        tenant: ${{ env.service-principal-tenant }}
        password: ${{ secrets.SERVICE_PRINCIPAL_TOKEN }}
        tag-regex: ${{ env.regex-feature }}
        days-to-keep: ${{ env.days-to-keep-feature }}
        keep: ${{ env.keep-feature }}
    
    - name: Purge Master Containers
      uses: Plabick/ACR-Container-Purge-Action@master
      with:
        registry: ${{ env.registry }}
        username: ${{ env.service-principal-username }}
        tenant: ${{ env.service-principal-tenant }}
        password: ${{ secrets.SERVICE_PRINCIPAL_TOKEN }}
        tag-regex: ${{ env.regex-master }}
        days-to-keep: ${{ env.days-to-keep-master }}
        keep: ${{ env.keep-master }}

```

## Runs

This action is a `docker` action.
