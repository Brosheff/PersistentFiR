using EFT;
using HarmonyLib;

namespace Brosheff.PersistentFiR.Patches;

[HarmonyPatch(typeof(Profile), nameof(Profile.SetSpawnedInSession), new[] { typeof(bool) })]
internal static class ProfileSetSpawnedInSessionPatch
{
    [HarmonyPrefix]
    private static bool Prefix(Profile __instance, bool value)
    {
        // Allow normal calls that mark the profile/items as spawned in session.
        if (value)
        {
            return true;
        }

        // Safety fallback: if the profile is not fully initialized, do not block the original method.
        if (__instance?.Info == null)
        {
            return true;
        }

        // Scav profiles should keep the original behavior.
        if (__instance.Info.Side == EPlayerSide.Savage)
        {
            return true;
        }

        // Block SetSpawnedInSession(false) for non-Scav profiles so FiR status persists between raids.
        Plugin.LogSource.LogDebug(
            "Blocked Profile.SetSpawnedInSession(false) for PMC profile to preserve Found in Raid status."
        );

        return false;
    }
}
