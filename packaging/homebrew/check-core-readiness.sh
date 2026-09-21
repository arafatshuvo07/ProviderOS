#!/bin/sh
set -eu

source_root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
formula_path="$source_root/Formula/provideros.rb"
tap_name="local/provideros-readiness"
install_formula=false
installed_by_check=false
official_probe_root=""

case "${1:-}" in
  "") ;;
  --install) install_formula=true ;;
  *)
    echo "Usage: check-core-readiness.sh [--install]" >&2
    exit 2
    ;;
esac

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required to check the formula." >&2
  exit 1
fi

if brew tap | grep -qx "$tap_name"; then
  echo "Temporary tap $tap_name already exists; remove it before rerunning." >&2
  exit 1
fi

cleanup() {
  if [ "$installed_by_check" = true ]; then
    brew uninstall "$tap_name/provideros" >/dev/null 2>&1 || true
  fi
  brew untap "$tap_name" >/dev/null 2>&1 || true
  if [ -n "$official_probe_root" ]; then
    rm -rf -- "$official_probe_root"
  fi
}
trap cleanup EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

brew tap-new --no-git "$tap_name" >/dev/null
tap_root=$(brew --repository "$tap_name")
cp "$formula_path" "$tap_root/Formula/provideros.rb"

# Homebrew applies additional formula rules only when the path belongs to an
# official tap. The temporary third-party tap below is still needed for install
# and audit commands, but it cannot catch those rules by itself. Mirror the
# formula into an isolated official-looking path so local checks exercise the
# same style policy as homebrew/core CI.
official_probe_root=$(mktemp -d "${TMPDIR:-/tmp}/provideros-homebrew-core.XXXXXX")
official_formula_dir="$official_probe_root/Taps/homebrew/homebrew-core/Formula/c"
mkdir -p "$official_formula_dir"
cp "$formula_path" "$official_formula_dir/provideros.rb"

brew style "$official_formula_dir/provideros.rb"
brew style "$tap_root/Formula/provideros.rb"
formula_url=$(sed -n 's/^[[:space:]]*url "\([^"]*\)"/\1/p' "$formula_path")
if curl --fail --silent --show-error --location --head "$formula_url" >/dev/null 2>&1; then
  brew audit --strict --new --online --formula "$tap_name/provideros"
else
  # The first main-branch commit necessarily points at a future release asset.
  # Keep the pre-release CI green until the tag publishes it. Homebrew's audit
  # still performs a URL reachability check even without --online, so there is
  # no meaningful local audit to run against a not-yet-created asset. A
  # release/tag validation can rerun this check online once that asset exists.
  echo "ProviderOS release asset is not published yet; skipping Homebrew URL audit."
fi

if [ "$install_formula" = true ]; then
  if brew list --formula provideros >/dev/null 2>&1; then
    echo "provideros is already installed; refusing to replace the user's formula." >&2
    exit 1
  fi
  brew install --build-from-source "$tap_name/provideros"
  installed_by_check=true
  brew test "$tap_name/provideros"
  brew uninstall "$tap_name/provideros"
  installed_by_check=false
fi

echo "Homebrew core readiness checks passed."
