# Persistent FiR

인레이드(Found in Raid, FiR) 상태의 아이템을 레이드에 들고 들어가도 FiR 상태가 꺼지지 않게 하는 SPT 클라이언트 모드입니다.

## 제작자

Brosheff

## 버전

1.0.0

## 리포지토리

https://github.com/Brosheff/PersistentFiR

## 기능

- 기존 FiR 아이템을 레이드에 가져가도 FiR 상태가 유지됩니다.
- 스캐브 프로필과 `SetSpawnedInSession(true)` 호출은 원래대로 동작합니다.
- 봇 전리품을 새로 FiR로 만드는 모드는 아닙니다.
- 아이템 생성, 루팅 테이블, 전리품 생성 방식은 변경하지 않습니다.

## 동작 방식

이 모드는 `EFT.Profile.SetSpawnedInSession(bool value)`를 Harmony로 패치합니다.

게임이 비스캐브 프로필에 대해 `SetSpawnedInSession(false)`를 호출하려고 하면, 그 호출을 차단해서 기존 FiR 상태가 유지되도록 합니다.

## 호환성

SPT 4.0.13 기준으로 제작했습니다.

다른 SPT 버전과의 호환성은 보장하지 않습니다.

Fika 호환성은 확인되지 않았습니다.

## 설치

릴리즈 압축 파일을 다운로드한 뒤 SPT 설치 폴더에 압축 해제하세요.

최종 DLL 위치는 아래와 같아야 합니다.

```text
BepInEx\plugins\PersistentFiR.dll
```

## 소스 빌드

`PersistentFiR.sln`을 Visual Studio 2022로 여세요.

이 프로젝트는 로컬 SPT 설치 폴더에 있는 필수 DLL을 참조합니다. 해당 DLL들은 이 리포지토리에 포함되어 있지 않습니다.

기본 SPT 경로는 아래로 가정합니다.

```text
C:\SPT
```

SPT가 다른 위치에 있다면 아래처럼 빌드하세요.

```powershell
dotnet build .\PersistentFiR.csproj -c Release /p:SPTPath="C:\Path\To\Your\SPT"
```

또는 로컬 빌드 스크립트를 사용할 수 있습니다.

```powershell
.\build-local.ps1 -GameRoot "C:\Path\To\Your\SPT"
```

이 스크립트는 DLL을 빌드하고, 로컬 SPT의 `BepInEx\plugins` 폴더에 복사하며, 배포용 `Build` 폴더도 생성합니다.

필요한 로컬 참조 DLL은 다음과 같습니다.

```text
BepInEx\core\BepInEx.dll
BepInEx\core\0Harmony.dll
EscapeFromTarkov_Data\Managed\Assembly-CSharp.dll
EscapeFromTarkov_Data\Managed\UnityEngine.dll
EscapeFromTarkov_Data\Managed\UnityEngine.CoreModule.dll
```

## 라이선스

이 프로젝트는 MIT License를 사용합니다.
