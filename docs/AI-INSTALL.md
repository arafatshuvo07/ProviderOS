# ProviderOS: install instructions for an AI assistant

This file is intentionally self-contained. Give this URL to Codex, Claude, or
another coding assistant and ask it to follow the procedure exactly:

<https://github.com/arafatshuvo07/ProviderOS/blob/main/docs/AI-INSTALL.md>

The assistant needs local terminal access on the destination computer and an
explicit request to install. A repository link in a browser-only chat does not
grant access to that computer.

The default desktop setup includes the local router, ProviderOS Control Center,
and menu-bar/tray app. On macOS it also includes the built-in Dynamic
Island/Desktop panel. The installer never needs a provider API key to be
embedded in a prompt. Credentials must be entered by the person at the local
terminal or saved through the operating system credential store.

## Copyable request

```text
Install ProviderOS from https://github.com/arafatshuvo07/ProviderOS on this
computer. First inspect README.md, AGENTS.md, docs/AI-INSTALL.md, and
docs/INSTALL.md. Install the router AND ProviderOS desktop app, Control Center,
and menu-bar/tray companion. Do not ask
me to paste API keys into chat, do not use a random fork, and do not overwrite
an unrelated directory. Detect the operating system and architecture, check
that Git and Node.js 22.19+ are available. Check the documented Python/uv and
platform dependencies; on macOS the app build requires full Xcode. Resolve
missing prerequisites within my granted permissions and report any blocker.
Preserve my existing client settings and authentication. Use my requested
client target (the commands below target Codex), then run the official installer:

macOS/Linux:
  curl -fsSL https://raw.githubusercontent.com/arafatshuvo07/ProviderOS/main/install.sh | sh -s -- --target codex --guided --with-tray

Windows PowerShell:
  $script = Join-Path $env:TEMP "provideros-install.ps1"
  Invoke-WebRequest -Uri https://raw.githubusercontent.com/arafatshuvo07/ProviderOS/main/install.ps1 -OutFile $script
  & powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $script -Target codex -Guided -WithTray

Use ProviderOS as the primary command. Let the local user choose providers and enter secrets
interactively. After installation, verify `provideros doctor`, the health
endpoint, the ProviderOS app, and the configured client integration. Report the
exact install directory, state directory, app path, version, and any failed
check. On macOS also verify the built-in Dynamic Island/Desktop panel.
Never claim success without showing those checks, and do not call a headless-only
setup complete unless I explicitly requested it. Leave the final client restart
to me if it would interrupt this session.
```

## Supported install paths

For a normal macOS or Linux install:

```sh
curl -fsSL https://raw.githubusercontent.com/arafatshuvo07/ProviderOS/main/install.sh | sh -s -- --target codex --guided --with-tray
```

For an explicit checkout (useful for review or development):

```sh
git clone https://github.com/arafatshuvo07/ProviderOS.git
cd ProviderOS
./install.sh --target codex --guided --with-tray
```

For Windows PowerShell:

```powershell
$script = Join-Path $env:TEMP "provideros-install.ps1"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/arafatshuvo07/ProviderOS/main/install.ps1 -OutFile $script
& powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $script -Target codex -Guided -WithTray
```

Use another supported target only when requested. For a desktop installation,
missing build prerequisites or an app that does not launch must be reported as
unfinished setup. Only an explicitly requested headless installation can be
complete without the desktop app.

On macOS, the documented build path requires full Xcode, not just standalone
Command Line Tools. Follow the Xcode selection guidance in the README. Verify
the desktop panel through **Settings → Dynamic Island → Desktop** in the
menu-bar app; it is not an item in macOS's Edit Widgets gallery.

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
