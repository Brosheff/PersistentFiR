param(
    [string]$GameRoot = "",
    [switch]$NoPause
)

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
$ErrorActionPreference = "Stop"

$ProjectRoot = $PSScriptRoot
$ProjectFile = Join-Path $ProjectRoot "PersistentFiR.csproj"
$BuildRoot = Join-Path $ProjectRoot "Build"
$DistributionPluginDir = Join-Path $BuildRoot "BepInEx\plugins"

function Test-SptGameRoot {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $false
    }

    return (Test-Path (Join-Path $Path "BepInEx\core\BepInEx.dll")) -and
        (Test-Path (Join-Path $Path "BepInEx\core\0Harmony.dll")) -and
        (Test-Path (Join-Path $Path "EscapeFromTarkov_Data\Managed\Assembly-CSharp.dll")) -and
        (Test-Path (Join-Path $Path "EscapeFromTarkov_Data\Managed\UnityEngine.dll")) -and
        (Test-Path (Join-Path $Path "EscapeFromTarkov_Data\Managed\UnityEngine.CoreModule.dll"))
}

if ([string]::IsNullOrWhiteSpace($GameRoot)) {
    $SearchRoots = @(
        $ProjectRoot,
        (Join-Path $ProjectRoot ".."),
        (Join-Path $ProjectRoot "..\.."),
        (Join-Path $ProjectRoot "..\..\..")
    )

    foreach ($candidate in $SearchRoots) {
        $resolvedCandidate = [System.IO.Path]::GetFullPath($candidate)
        if (Test-SptGameRoot $resolvedCandidate) {
            $GameRoot = $resolvedCandidate
            break
        }
    }
}

if (-not (Test-SptGameRoot $GameRoot)) {
    throw 'SPT game root could not be found. Run build-local.ps1 -GameRoot "C:\Path\To\Your\SPT".'
}

$Root = [System.IO.Path]::GetFullPath($GameRoot)
$InstallPluginDir = Join-Path $Root "BepInEx\plugins"
$InstalledDll = Join-Path $InstallPluginDir "PersistentFiR.dll"

Write-Host "=== PersistentFiR build/install start ===" -ForegroundColor Cyan
Write-Host "Project root: $ProjectRoot"
Write-Host "Game root: $Root"

try {
    $RequiredRefs = @(
        (Join-Path $Root "BepInEx\core\BepInEx.dll"),
        (Join-Path $Root "BepInEx\core\0Harmony.dll"),
        (Join-Path $Root "EscapeFromTarkov_Data\Managed\Assembly-CSharp.dll"),
        (Join-Path $Root "EscapeFromTarkov_Data\Managed\UnityEngine.dll"),
        (Join-Path $Root "EscapeFromTarkov_Data\Managed\UnityEngine.CoreModule.dll")
    )

    Write-Host ""
    Write-Host "Checking reference DLLs..." -ForegroundColor Cyan
    foreach ($ref in $RequiredRefs) {
        if (!(Test-Path $ref)) {
            throw "Build reference DLL was not found: $ref"
        }

        Write-Host "  OK $ref" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "=== Building DLL ===" -ForegroundColor Cyan
    dotnet build "$ProjectFile" -c Release "/p:SPTPath=$Root"

    if ($LASTEXITCODE -ne 0) {
        throw "dotnet build failed"
    }

    $BuildOutputDir = Join-Path $ProjectRoot "bin\Release
etstandard2.1"
    $BuiltDll = Join-Path $BuildOutputDir "PersistentFiR.dll"
    if (!(Test-Path $BuiltDll)) {
        throw "Built DLL was not found: $BuiltDll"
    }

    if (Test-Path $BuildRoot) {
        Remove-Item $BuildRoot -Recurse -Force
    }

    New-Item -ItemType Directory -Force -Path $InstallPluginDir | Out-Null
    New-Item -ItemType Directory -Force -Path $DistributionPluginDir | Out-Null

    Copy-Item $BuiltDll $InstalledDll -Force
    Copy-Item $BuiltDll (Join-Path $DistributionPluginDir "PersistentFiR.dll") -Force

    foreach ($file in @("README.md", "README_ko.md", "LICENSE")) {
        $source = Join-Path $ProjectRoot $file
        if (Test-Path $source) {
            Copy-Item $source (Join-Path $BuildRoot $file) -Force
        }
    }

    Write-Host ""
    Write-Host "=== Done ===" -ForegroundColor Green
    Write-Host "Installed DLL: $InstalledDll"
    Write-Host "Distribution tree: $BuildRoot"
}
catch {
    Write-Host ""
    Write-Host "=== Failed ===" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

Write-Host ""
if (-not $NoPause) {
    Read-Host "Press Enter to close this window"
}
