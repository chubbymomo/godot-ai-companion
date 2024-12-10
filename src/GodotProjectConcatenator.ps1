# Enhanced Godot Project Concatenator
[CmdletBinding()]
param(
    [ValidateSet('full', 'summary', 'incremental')]
    [string]$OutputMode = "full",
    [ValidateRange(1KB, 10MB)]
    [int]$MaxChunkSize = 500KB,
    [string]$FocusPath = "",
    [bool]$IncludeStats = $true
)

# Get the current directory where the script is run
$projectRoot = Get-Location
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$totalSize = 0
$fileCount = 0

# Define file patterns to include
$includePatterns = @(
    "*.cs",      # C# source files
    "*.tscn",    # Godot scene files
    "*.tres",    # Godot resource files
    "*.gdignore", # Godot ignore files
    "*.import",   # Godot import files
    "*.cfg",      # Configuration files
    "*.gd",       # GDScript files
    "*.csproj",   # C# project files
    "*.sln",      # Solution files
    "project.godot", # Main Godot project file
    "*.shader"    # Shader files
)

# Define directories to exclude
$excludeDirs = @(
    ".godot",     # Godot cache directory
    ".mono",      # Mono compilation directory
    "bin",        # Binary output
    "obj",        # Object files
    ".vs",        # Visual Studio directory
    ".idea",      # Rider IDE directory
    "*.tmp",      # Temporary files
    "node_modules" # Node modules if using them
)

# File categories for smart summarization
$fileCategories = @{
    "Core" = @("project.godot", "*.csproj", "*.sln")
    "Scripts" = @("*.cs", "*.gd")
    "Scenes" = @("*.tscn")
    "Resources" = @("*.tres", "*.shader")
    "Config" = @("*.cfg", "*.import")
}

# Function to calculate file hash for change detection
function Get-FileHash($filePath) {
    $hashResult = Microsoft.PowerShell.Utility\Get-FileHash -Path $filePath -Algorithm MD5
    return $hashResult.Hash
}

# Function to generate file summary
function Get-FileSummary($filePath) {
    $content = Get-Content -Path $filePath -Raw
    $lines = @($content -split "`n").Count
    $methods = if ($filePath -match '\.(cs|gd)$') {
        @([regex]::Matches($content, '(func |public.*?\(|private.*?\(|protected.*?\()')).Count
    } else { 0 }
    
    $fileItem = Get-Item -Path $filePath
    return @{
        Path = $filePath
        Lines = $lines
        Methods = $methods
        Size = $fileItem.Length
        LastModified = $fileItem.LastWriteTime
    }
}

# Create output directory if it doesn't exist
$outputDir = Join-Path -Path $projectRoot -ChildPath "project_exports"
$null = New-Item -ItemType Directory -Force -Path $outputDir

# Setup output files
$mainOutputFile = Join-Path -Path $outputDir -ChildPath "project_structure_${date}.txt"
$summaryFile = Join-Path -Path $outputDir -ChildPath "project_summary_${date}.txt"
$chunkPrefix = Join-Path -Path $outputDir -ChildPath "chunk"
$currentChunk = 1
$currentChunkSize = 0

# Write header
$headerText = @"
Godot Project Export - $date
====================================
Export Mode: $OutputMode
Focus Path: $(if ($FocusPath -eq "") { "All" } else { $FocusPath })

"@
Set-Content -Path $mainOutputFile -Value $headerText

# Process directory structure
"Directory Structure:" | Add-Content -Path $mainOutputFile
"-------------------" | Add-Content -Path $mainOutputFile

$dirStructure = Get-ChildItem -Directory -Recurse | 
    Where-Object { 
        $dirPath = $_.FullName
        $include = -not ($excludeDirs | Where-Object { $dirPath -like "*\$_*" })
        if ($FocusPath -ne "") {
            $include = $include -and $dirPath.StartsWith((Join-Path -Path $projectRoot -ChildPath $FocusPath))
        }
        $include
    }

foreach ($dir in $dirStructure) {
    $relativePath = $dir.FullName.Replace("$($projectRoot.Path)\", "")
    Add-Content -Path $mainOutputFile -Value $relativePath
}

# Initialize category summaries
$categorySummaries = @{}
foreach ($category in $fileCategories.Keys) {
    $categorySummaries[$category] = @{
        FileCount = 0
        TotalLines = 0
        TotalSize = 0
        Files = @()
    }
}

# Process files based on OutputMode
foreach ($pattern in $includePatterns) {
    Get-ChildItem -Path $projectRoot -Filter $pattern -Recurse -File | 
        Where-Object { 
            $filePath = $_.FullName
            $exclude = $false
            foreach ($excludeDir in $excludeDirs) {
                if ($filePath -like "*\$excludeDir\*") {
                    $exclude = $true
                    break
                }
            }
            if ($FocusPath -ne "") {
                $exclude = $exclude -or -not $filePath.StartsWith((Join-Path -Path $projectRoot -ChildPath $FocusPath))
            }
            -not $exclude
        } | ForEach-Object {
            $relativePath = $_.FullName.Replace("$($projectRoot.Path)\", "")
            $fileInfo = Get-FileSummary -filePath $_.FullName
            $totalSize += $_.Length
            $fileCount++

            # Update category summaries
            foreach ($category in $fileCategories.Keys) {
                if ($fileCategories[$category] | Where-Object { $relativePath -like $_ }) {
                    $categorySummaries[$category].FileCount++
                    $categorySummaries[$category].TotalLines += $fileInfo.Lines
                    $categorySummaries[$category].TotalSize += $fileInfo.Size
                    $categorySummaries[$category].Files += $relativePath
                }
            }

            # Handle chunking for full content
            if ($OutputMode -eq "full") {
                $content = if ($_.Extension -in @(".tscn", ".tres", ".import", ".cfg")) {
                    "<<File exists but content not included due to format>>"
                } else {
                    Get-Content -Path $_.FullName -Raw
                }

                $chunkContent = @"

=== File: $relativePath ===
$content
"@

                # Check if we need to start a new chunk
                if ($currentChunkSize + $content.Length -gt $MaxChunkSize) {
                    $currentChunk++
                    $currentChunkSize = 0
                }

                $chunkFile = "${chunkPrefix}_${currentChunk}.txt"
                Add-Content -Path $chunkFile -Value $chunkContent
                $currentChunkSize += $content.Length

                # Add reference to the chunk in main file
                Add-Content -Path $mainOutputFile -Value "File: $relativePath (Chunk $currentChunk)"
            }
        }
}

# Generate summary file with directory structure
$summaryContent = @"
Project Summary
==============
Total Files: $fileCount
Total Size: $([math]::Round($totalSize / 1KB, 2)) KB
Generated: $date

Directory Structure
================
$((Get-ChildItem -Directory -Recurse | 
    Where-Object { 
        $dirPath = $_.FullName
        -not ($excludeDirs | Where-Object { $dirPath -like "*\$_*" })
    } |
    ForEach-Object { $_.FullName.Replace("$($projectRoot.Path)\", "") } |
    ForEach-Object { "- $_" }) -join "`n")

Category Summaries
================
"@

Set-Content -Path $summaryFile -Value $summaryContent

foreach ($category in $fileCategories.Keys) {
    $summary = $categorySummaries[$category]
    $categorySummaryContent = @"

$category
--------
Files: $($summary.FileCount)
Total Lines: $($summary.TotalLines)
Size: $([math]::Round($summary.TotalSize / 1KB, 2)) KB
Files:
$(($summary.Files | ForEach-Object { "- $_" }) -join "`n")
"@
    Add-Content -Path $summaryFile -Value $categorySummaryContent
}

# Create manifest file
$manifestFile = Join-Path -Path $outputDir -ChildPath "export_manifest.json"
$manifestContent = @{
    ExportDate = $date
    Mode = $OutputMode
    FocusPath = $FocusPath
    TotalFiles = $fileCount
    TotalSize = $totalSize
    ChunkCount = $currentChunk
    Categories = $categorySummaries
} | ConvertTo-Json

Set-Content -Path $manifestFile -Value $manifestContent

# Output results
Write-Host "Export completed:"
Write-Host "- Main structure file: $mainOutputFile"
Write-Host "- Summary file: $summaryFile"
Write-Host "- Manifest file: $manifestFile"
Write-Host "- Number of chunks: $currentChunk"
Write-Host "- Total size: $([math]::Round($totalSize / 1KB, 2)) KB"