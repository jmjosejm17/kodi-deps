[CmdletBinding()]
Param(
  [switch] $Desktop,
  [switch] $App,
  [switch] $NoClean,
  [ValidateSet( 'arm', 'win32', 'x64', 'arm64' )]
  [string[]] $Platforms = @( 'arm', 'win32', 'x64', 'arm64'),
  [ValidateSet('10.0.17763.0', '10.0.18362.0')]
  [string] $SdkVersion = '10.0.17763.0',
  [ValidateSet(15, 16)]
  [int] $VsVersion = 15
)
$ErrorActionPreference = 'Stop'

if ($false -eq $NoClean) {
  $buildPath = Join-Path $PSScriptRoot -ChildPath 'Build'
  $packagePath = Join-Path $PSScriptRoot -ChildPath 'package'
  if (Test-Path $buildPath) {
    Remove-Item -Recurse -Force $buildPath
  }
  if (Test-Path $packagePath) {
    Remove-Item -Recurse -Force $packagePath
  }
}
.\BuildAllPlatforms.ps1 -Platforms $Platforms -GenerateProjects -Desktop:$Desktop -App:$App -VsVersion $VsVersion -SdkVersion $SdkVersion
.\BuildAllPlatforms.ps1 -Platforms $Platforms -Desktop:$Desktop -App:$App -Deb -Packages taglib, tinyxml, fmt, pcre, crossguid, lzo2, zlib, detours, libudfread, GoogleTest
.\BuildAllPlatforms.ps1 -Platforms $Platforms -Desktop:$Desktop -App:$App -Rel -Zip