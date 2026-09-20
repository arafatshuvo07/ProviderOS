[CmdletBinding(SupportsShouldProcess)]
param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$Arguments
)

# ProviderOS-branded deployment entrypoint. Keep the implementation in the
# historical filename so older automation can still invoke it during migration.
$legacy = Join-Path $PSScriptRoot "deploy-codex-router.ps1"
if (-not (Test-Path -LiteralPath $legacy -PathType Leaf)) {
  throw "ProviderOS deployment implementation is missing at $legacy."
}
& powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $legacy @Arguments
exit $LASTEXITCODE
