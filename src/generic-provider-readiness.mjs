import { readGenericProviders } from "./generic-provider-state.mjs";
import { PROVIDERS } from "./model-registry.mjs";
import { readProviderCredentialStore } from "./provider-credential-store.mjs";
import { resolveGenericProviderCredentialReference } from "./provider-credentials.mjs";

function credentialAvailable(provider) {
  const entry = readProviderCredentialStore().credentials.find(
    (candidate) => candidate.id === provider.credentialRef,
  );
  if (!entry || entry.state !== "active") return false;
  if (entry.providerType !== "generic" || entry.providerId !== provider.id) return false;
  if (entry.kind !== "api_key") return false;
  return Boolean(
    resolveGenericProviderCredentialReference(provider.id, entry.secretRef)?.value,
  );
}

// Catalog publication needs a boolean readiness answer, never the credential
// itself. Keep this separate from generic-providers.mjs so setup and provider
// selection do not import the undici request transport before npm dependencies
// have been installed. A credentialless endpoint is ready only after an
// operator explicitly registered and enabled it in generic provider state.
export function genericProviderConfigured(providerId) {
  return genericProviderEnabled(providerId) && genericProviderCredentialReady(providerId);
}

// The enabled half of `genericProviderConfigured`, so onboarding surfaces can
// label a disabled provider that already holds a working credential as
// reconnectable instead of asking for a key it would overwrite.
export function genericProviderEnabled(providerId) {
  try {
    return readGenericProviders({ reservedProviderIds: PROVIDERS })
      .some((entry) => entry.id === providerId && entry.enabled);
  } catch {
    return false;
  }
}

// The credential half alone: true when the descriptor needs no key or its
// bound credential is present. Deliberately ignores `enabled` — a disabled
// provider with a key must not re-prompt for it.
export function genericProviderCredentialReady(providerId) {
  try {
    const provider = readGenericProviders({ reservedProviderIds: PROVIDERS })
      .find((entry) => entry.id === providerId);
    if (!provider) return false;
    return !provider.credentialRef || credentialAvailable(provider);
  } catch {
    return false;
  }
}
