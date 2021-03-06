param (
    [Parameter(Mandatory = $false)]$registry = $env:registry,
    [Parameter(Mandatory = $false)]$username = $env:username ,
    [Parameter(Mandatory = $false)]$tenant = $env:tenant,
    [Parameter(Mandatory = $false)]$password = $env:password,
    [Parameter(Mandatory = $false)]$repoTarget = $env:repo,
    [Parameter(Mandatory = $false)]$tagRegex = $env:tagRegex,
    [Parameter(Mandatory = $false)]$repoRegex = $env:repoRegex ,
    [Parameter(Mandatory = $false)]$daysToKeep = $env:daysToKeep,
    [Parameter(Mandatory = $false)]$keep = $env:keep,
    [Parameter(Mandatory = $false)]$dryRun = $env:dryRun,
    [Parameter(Mandatory = $false)]$deleteUntagged = $env:deleteUntagged 
)
az login --service-principal -u $username -p $password --tenant $tenant
Write-Host "-----Logged In -----"
If ($dryRun -eq $true) {
    Write-Output "-----Dry Run-----"
    $dryRunCommand = "--dry-run"
}
Else {
    $dryRunCommand = ""
}
$deleteUntaggedCommand = If ($deleteUntagged -eq $true) { "--untagged" } { "" }
if ($repoTarget -eq "all") {
    $REPOS = az acr repository list -n $registry  | Where-Object { ($_ –ne "[") -and ($_ –ne "]") }
    foreach ($REPO in $REPOS) {
        if ($REPO -match $repoRegex) {
            $REPO = $REPO.Replace(" ", "").Replace(",", "")
            Write-Output "----- Purging $REPO -----"
            az acr run --registry $registry --cmd "acr purge --ago ${daysToKeep}d --keep $keep --filter '${REPO}:$tagRegex' $dryRunCommand $deleteUntaggedCommand" /dev/null
        }	
    }
}
else {
    az acr run --registry $registry --cmd "acr purge --ago ${daysToKeep}d --keep $keep --filter '${repoTarget}:$tagRegex' $dryRunCommand $deleteUntaggedCommand" /dev/null
}
