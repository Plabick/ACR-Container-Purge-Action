#!/usr/bin/env sh
set -e # Abort at first error
echo "Running \"pwsh /purge.ps1 -registry "$1" -username "$2" -tenant "$3" -password "$4" -repoTarget "$5" -tagRegex "$6" -repoRegex "$7" -daysToKeep "$8" -keep "$9" -dryRun "$DRYRUN" -deleteUntagged "$UNTAGGED"\""
pwsh /purge.ps1 -registry "$1" -username "$2" -tenant "$3" -password "$4" -repoTarget "$5" -tagRegex "$6" -repoRegex "$7" -daysToKeep "$8" -keep "$9" -dryRun "$DRYRUN  -deleteUntagged "$UNTAGGED""
