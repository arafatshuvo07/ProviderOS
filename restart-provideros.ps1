[CmdletBinding()]
param(
  [string]$InstallDir = $(
    if ($env:LOCALAPPDATA) { Join-Path $env:LOCALAPPDATA "provideros" }
    else { Join-Path $HOME ".local\share\provideros" }
  )
)

$ErrorActionPreference = "Stop"
$routerRoot = [IO.Path]::GetFullPath($InstallDir)
if (-not (Test-Path (Join-Path $routerRoot "src\service.mjs"))) {
  $legacyRoot = if ($env:LOCALAPPDATA) { Join-Path $env:LOCALAPPDATA "codex-router" } else { Join-Path $HOME ".local\share\codex-router" }
  if (Test-Path (Join-Path $legacyRoot "src\service.mjs")) {
    $routerRoot = [IO.Path]::GetFullPath($legacyRoot)
  } else {
    throw "Installed ProviderOS not found at $routerRoot."
  }
}
Push-Location $routerRoot
try {
  Write-Host "Gracefully restarting ProviderOS..."
  & node (Join-Path $routerRoot "src\service.mjs") restart
  $RestartExitCode = $LASTEXITCODE
  if ($RestartExitCode -ne 0) {
    throw "ProviderOS restart failed with exit code $RestartExitCode."
  }
} finally {
  Pop-Location
}

Write-Host "ProviderOS is running."
