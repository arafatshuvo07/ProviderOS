[CmdletBinding()]
param()

# ProviderOS is the public Windows command. The historical script remains a
# compatibility implementation so upgrades do not strand existing shortcuts.
$legacy = Join-Path $PSScriptRoot "codex-router.ps1"
if (-not (Test-Path -LiteralPath $legacy -PathType Leaf)) {
  throw "ProviderOS command implementation is missing at $legacy."
}
& powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $legacy @args
exit $LASTEXITCODE
