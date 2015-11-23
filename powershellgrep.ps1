[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)]
  [string]$sourcefile,
	
  [Parameter(Mandatory=$True)]
  [string]$targetfile,

  [Parameter(Mandatory=$True)]
  [string]$find,

  [Parameter(Mandatory=$True)]
  [string]$replace
)

$replaces = 0

$lines=Get-Content $sourcefile
$newlines = foreach ($line in $lines) {$line -replace $find, $replace}
Set-Content $targetfile $newlines

