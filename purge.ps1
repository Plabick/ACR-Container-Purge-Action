param (
	[Parameter(Mandatory = $false)]$registry = $env:registry,
	[Parameter(Mandatory = $false)]$username = $env:username ,
	[Parameter(Mandatory = $false)]$tenant = $env:tenant,
	[Parameter(Mandatory = $false)]$password = $env:password,
	[Parameter(Mandatory = $false)]$repoTarget = $env:repo,
	[Parameter(Mandatory = $false)]$tagRegex = $env:tagRegex,
	[Parameter(Mandatory = $false)]$repoRegex = $env:repoRegex ,
	[Parameter(Mandatory = $false)]$daysToKeep = $env:daysToKeep,
	[Parameter(Mandatory = $false)]$keep = $env:keep
)

az login --service-principal -u $username -p $password --tenant $tenant

if ($repoTarget -eq "all") {
	az acr run --registry $registry --cmd "acr purge --ago $daysToKeep --keep $keep --filter '${repoTarget}:$tagRegex' " /dev/null
}
else {
	$REPOS = az acr repository list -n $registry
	foreach ($REPO in $REPOS) {
  $REPO = $REPO.Replace(",", "").Replace(" ", "")
  if ( ($REPO -match $repoRegex) && ($REPO -ne "[") && ($REPO -ne "]")) {
			Write-Output "----- Purging $REPO -----"
			az acr run --registry $registry --cmd "acr purge --ago $daysToKeep --keep $keep --filter '${REPO}:$tagRegex' " /dev/null
		}
	}
}
