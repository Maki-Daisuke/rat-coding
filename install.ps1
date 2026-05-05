[CmdletBinding()]
param(
    [switch]$Force,
    [string]$Source = $env:RAT_CODING_SOURCE,
    [string]$Repository = $(if ($env:RAT_CODING_REPOSITORY) { $env:RAT_CODING_REPOSITORY } else { "https://github.com/yanother/rat-coding" }),
    [string]$Ref = $(if ($env:RAT_CODING_REF) { $env:RAT_CODING_REF } else { "main" })
)

$ErrorActionPreference = "Stop"

function Get-RelativeFileMap {
    param([Parameter(Mandatory = $true)][string]$Root)

    $rootItem = Get-Item -LiteralPath $Root
    $prefixLength = $rootItem.FullName.Length

    $map = @{}
    Get-ChildItem -LiteralPath $Root -Recurse -File | ForEach-Object {
        $relativePath = $_.FullName.Substring($prefixLength).TrimStart([char]'\\', [char]'/').Replace('\\', '/')
        $map[$relativePath] = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
    }

    return $map
}

function Test-DirectoryContentEqual {
    param(
        [Parameter(Mandatory = $true)][string]$SourcePath,
        [Parameter(Mandatory = $true)][string]$DestinationPath
    )

    if (-not (Test-Path -LiteralPath $DestinationPath -PathType Container)) {
        return $false
    }

    $sourceMap = Get-RelativeFileMap -Root $SourcePath
    $destinationMap = Get-RelativeFileMap -Root $DestinationPath

    if ($sourceMap.Count -ne $destinationMap.Count) {
        return $false
    }

    foreach ($relativePath in $sourceMap.Keys) {
        if (-not $destinationMap.ContainsKey($relativePath)) {
            return $false
        }
        if ($sourceMap[$relativePath] -ne $destinationMap[$relativePath]) {
            return $false
        }
    }

    return $true
}

function Test-FileContentEqual {
    param(
        [Parameter(Mandatory = $true)][string]$SourcePath,
        [Parameter(Mandatory = $true)][string]$DestinationPath
    )

    if (-not (Test-Path -LiteralPath $DestinationPath -PathType Leaf)) {
        return $false
    }

    $sourceHash = (Get-FileHash -LiteralPath $SourcePath -Algorithm SHA256).Hash
    $destinationHash = (Get-FileHash -LiteralPath $DestinationPath -Algorithm SHA256).Hash
    return $sourceHash -eq $destinationHash
}

function Get-RatCodingSource {
    param(
        [string]$Source,
        [string]$Repository,
        [string]$Ref
    )

    if ($Source) {
        $resolvedSource = Resolve-Path -LiteralPath $Source
        return @{ Root = $resolvedSource.Path; TemporaryRoot = $null }
    }

    $temporaryRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("rat-coding-" + [System.Guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Path $temporaryRoot | Out-Null

    $archivePath = Join-Path $temporaryRoot "rat-coding.zip"
    $archiveUrl = "$($Repository.TrimEnd('/'))/archive/refs/heads/$Ref.zip"

    Write-Host "Downloading Rat-Coding from $archiveUrl"
    Invoke-WebRequest -Uri $archiveUrl -OutFile $archivePath
    Expand-Archive -LiteralPath $archivePath -DestinationPath $temporaryRoot

    $expandedRoot = Get-ChildItem -LiteralPath $temporaryRoot -Directory | Where-Object { $_.Name -ne "__MACOSX" } | Select-Object -First 1
    if (-not $expandedRoot) {
        throw "Could not find the expanded Rat-Coding source directory."
    }

    return @{ Root = $expandedRoot.FullName; TemporaryRoot = $temporaryRoot }
}

function Copy-FileChecked {
    param(
        [Parameter(Mandatory = $true)][string]$SourcePath,
        [Parameter(Mandatory = $true)][string]$DestinationPath,
        [Parameter(Mandatory = $true)][bool]$ForceInstall
    )

    if (Test-Path -LiteralPath $DestinationPath) {
        if (Test-FileContentEqual -SourcePath $SourcePath -DestinationPath $DestinationPath) {
            Write-Host "Up to date: $DestinationPath"
            return
        }
        if (-not $ForceInstall) {
            throw "Refusing to overwrite existing file: $DestinationPath. Re-run with -Force if this is intentional."
        }
    }

    $destinationDirectory = Split-Path -Parent $DestinationPath
    New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
    Copy-Item -LiteralPath $SourcePath -Destination $DestinationPath -Force
    Write-Host "Installed: $DestinationPath"
}

function Copy-DirectoryChecked {
    param(
        [Parameter(Mandatory = $true)][string]$SourcePath,
        [Parameter(Mandatory = $true)][string]$DestinationPath,
        [Parameter(Mandatory = $true)][bool]$ForceInstall
    )

    if (Test-Path -LiteralPath $DestinationPath) {
        if (Test-DirectoryContentEqual -SourcePath $SourcePath -DestinationPath $DestinationPath) {
            Write-Host "Up to date: $DestinationPath"
            return
        }
        if (-not $ForceInstall) {
            throw "Refusing to overwrite existing directory: $DestinationPath. Re-run with -Force if this is intentional."
        }
    }

    New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
    Get-ChildItem -LiteralPath $SourcePath | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $DestinationPath -Recurse -Force
    }
    Write-Host "Installed: $DestinationPath"
}

$sourceInfo = $null

try {
    $sourceInfo = Get-RatCodingSource -Source $Source -Repository $Repository -Ref $Ref
    $sourceRoot = $sourceInfo.Root
    $targetRoot = (Get-Location).Path

    $sourceAgents = Join-Path $sourceRoot "AGENTS.md"
    $sourceSkills = Join-Path $sourceRoot ".agents\skills"

    if (-not (Test-Path -LiteralPath $sourceAgents -PathType Leaf)) {
        throw "Rat-Coding source is missing AGENTS.md: $sourceAgents"
    }
    if (-not (Test-Path -LiteralPath $sourceSkills -PathType Container)) {
        throw "Rat-Coding source is missing .agents/skills: $sourceSkills"
    }

    Copy-FileChecked -SourcePath $sourceAgents -DestinationPath (Join-Path $targetRoot "AGENTS.md") -ForceInstall $Force.IsPresent

    $targetSkillsRoot = Join-Path $targetRoot ".agents\skills"
    New-Item -ItemType Directory -Path $targetSkillsRoot -Force | Out-Null

    Get-ChildItem -LiteralPath $sourceSkills -Directory | Sort-Object Name | ForEach-Object {
        Copy-DirectoryChecked -SourcePath $_.FullName -DestinationPath (Join-Path $targetSkillsRoot $_.Name) -ForceInstall $Force.IsPresent
    }

    Write-Host "Rat-Coding installed for workspace scope at $targetRoot"
}
finally {
    if ($sourceInfo -and $sourceInfo.TemporaryRoot -and (Test-Path -LiteralPath $sourceInfo.TemporaryRoot)) {
        Remove-Item -LiteralPath $sourceInfo.TemporaryRoot -Recurse -Force
    }
}