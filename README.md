# Persistent FiR

Persistent FiR is a BepInEx client plugin for SPT that prevents items with Found in Raid status from losing that status when brought into a raid.

## Author

Brosheff

## Version

1.0.0

## Repository

https://github.com/Brosheff/PersistentFiR

## Features

- Keeps existing Found in Raid items marked as FiR after entering a raid.
- Allows Scav profiles and `SetSpawnedInSession(true)` calls to behave normally.
- Does not mark bot loot as Found in Raid.
- Does not add new items or change loot generation.

## How It Works

Persistent FiR patches `EFT.Profile.SetSpawnedInSession(bool value)` with Harmony.

When the game calls `SetSpawnedInSession(false)` for a non-Scav profile, the mod blocks that call so existing FiR state is preserved.

## Compatibility

Built for SPT 4.0.13.

Compatibility with other SPT versions is not guaranteed.

Fika compatibility is unknown.

## Installation

Download the release archive and extract it into your SPT installation folder.

The final DLL should be located at:

```text
BepInEx\plugins\PersistentFiR.dll
```

## Building from Source

Open `PersistentFiR.sln` in Visual Studio 2022.

This project references required assemblies from a local SPT installation. These assemblies are not included in this repository.

Default expected SPT path:

```text
C:\SPT
```

If your SPT installation is elsewhere, build with:

```powershell
dotnet build .\PersistentFiR.csproj -c Release /p:SPTPath="C:\Path\To\Your\SPT"
```

Or use the local build script:

```powershell
.\build-local.ps1 -GameRoot "C:\Path\To\Your\SPT"
```

The script builds the DLL, copies it to your local SPT `BepInEx\plugins` folder, and creates a release-ready `Build` folder.

Required local references:

```text
BepInEx\core\BepInEx.dll
BepInEx\core\0Harmony.dll
EscapeFromTarkov_Data\Managed\Assembly-CSharp.dll
EscapeFromTarkov_Data\Managed\UnityEngine.dll
EscapeFromTarkov_Data\Managed\UnityEngine.CoreModule.dll
```

## License

This project is licensed under the MIT License.
