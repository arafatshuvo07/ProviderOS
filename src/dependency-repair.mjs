export function isHomebrewManaged(
  packageManager = process.env.CODEX_ROUTER_PACKAGE_MANAGER,
) {
  return packageManager === "homebrew";
}

export function dependencyRepairHint({
  packageManager = process.env.CODEX_ROUTER_PACKAGE_MANAGER,
  platform = process.platform,
} = {}) {
  if (isHomebrewManaged(packageManager)) {
    return "Run `brew reinstall provideros` to rebuild the package-managed dependencies";
  }
  if (platform === "win32") {
    return "Run `./provideros.ps1 doctor --fix` or `./install.ps1 -CheckoutInstall -ForceDeps`";
  }
  return "Run `./bin/doctor --fix` or `./bin/install --force-deps`";
}
