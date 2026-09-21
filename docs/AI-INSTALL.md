# ProviderOS: install instructions for an AI assistant

This file is intentionally self-contained. Give this URL to Codex, Claude, or
another coding assistant and ask it to follow the procedure exactly:

<https://github.com/arafatshuvo07/ProviderOS/blob/main/docs/AI-INSTALL.md>

ProviderOS is a local model-provider router with an optional desktop Control
Center and menu-bar app. The installer never needs a provider API key to be
embedded in a prompt. Credentials must be entered by the person at the local
terminal or saved through the operating system credential store.

## Copyable request

```text
Install ProviderOS from https://github.com/arafatshuvo07/ProviderOS on this
computer. First inspect the repository README and docs/INSTALL.md. Do not ask
me to paste API keys into chat, do not use a random fork, and do not overwrite
an unrelated directory. Detect the operating system and architecture, check
that Git and Node.js 22.19+ are available, then run the official installer:

macOS/Linux:
  curl -fsSL https://raw.githubusercontent.com/arafatshuvo07/ProviderOS/main/install.sh | sh

Windows PowerShell:
  $script = Join-Path $env:TEMP "provideros-install.ps1"
  Invoke-WebRequest -Uri https://raw.githubusercontent.com/arafatshuvo07/ProviderOS/main/install.ps1 -OutFile $script
  & powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $script

Use ProviderOS as the primary command and install the optional desktop app when
the machine supports it. Let the local user choose providers and enter secrets
interactively. After installation, verify `provideros doctor`, the health
endpoint, the ProviderOS app, and the configured client integration. Report the
exact install directory, state directory, app path, version, and any failed
check. Never claim success without showing those checks.
```

## Supported install paths

For a normal macOS or Linux install:

```sh
curl -fsSL https://raw.githubusercontent.com/arafatshuvo07/ProviderOS/main/install.sh | sh
```

For an explicit checkout (useful for review or development):

```sh
git clone https://github.com/arafatshuvo07/ProviderOS.git
cd ProviderOS
./install.sh --with-tray
```

For Windows PowerShell:

```powershell
$script = Join-Path $env:TEMP "provideros-install.ps1"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/arafatshuvo07/ProviderOS/main/install.ps1 -OutFile $script
& powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $script -WithTray
```

The desktop build is optional. A headless installation is complete when the
router health check and the selected client integration pass.

## Verification checklist

The assistant should run these checks and include their output summary:

```sh
provideros --version
provideros doctor
curl -fsS http://127.0.0.1:4202/health
```

On macOS, verify that `~/Applications/ProviderOS.app` exists and opens. On
Windows, verify the ProviderOS executable under the managed checkout's
`apps/control-center/release/win-unpacked` directory. On Linux, verify the
ProviderOS AppImage or the running `provideros-control-center` binary.

The assistant must confirm that the requested client (Codex, Cursor, Gemini
CLI, DeepSeek Harness, Claude Code, or OpenClaw) sees the selected models. A
provider can be shown as unavailable when no credential was supplied; that is
an authentication state, not an installation failure.

## Safe recovery

ProviderOS keeps generated state and configuration backups in the user's
configuration directory. If an update fails, run:

```sh
provideros rollback
```

Ask the assistant to inspect `provideros doctor` and the support bundle before
changing files manually. Never delete the state directory to fix a provider
credential problem; that can remove model catalogs and local session metadata.
