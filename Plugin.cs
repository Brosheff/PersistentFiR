using System;
using BepInEx;
using BepInEx.Logging;
using HarmonyLib;

namespace Brosheff.PersistentFiR;

[BepInPlugin(PluginGuid, PluginName, PluginVersion)]
public sealed class Plugin : BaseUnityPlugin
{
    public const string PluginGuid = "com.brosheff.persistentfir";
    public const string PluginName = "PersistentFiR";
    public const string PluginVersion = "1.0.0";

    internal static ManualLogSource LogSource { get; private set; } = null!;

    private Harmony? _harmony;

    private void Awake()
    {
        LogSource = Logger;

        try
        {
            _harmony = new Harmony(PluginGuid);
            _harmony.PatchAll(typeof(Plugin).Assembly);
            LogSource.LogInfo($"{PluginName} {PluginVersion} loaded.");
        }
        catch (Exception ex)
        {
            LogSource.LogError($"Failed to load {PluginName}: {ex}");
        }
    }

    private void OnDestroy()
    {
        try
        {
            _harmony?.UnpatchSelf();
        }
        catch (Exception ex)
        {
            LogSource.LogWarning($"Failed to unpatch {PluginName}: {ex}");
        }
    }
}
