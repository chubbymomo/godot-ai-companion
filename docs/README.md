# Usage Guide

## Overview

The Godot Project Concatenator is a PowerShell script that creates organized exports of Godot projects for AI assistance. This guide covers all aspects of using the tool effectively.

## Basic Usage

### Simple Export
```powershell
.\GodotProjectConcatenator.ps1
```
This creates a full export using default settings.

### Parameters

```powershell
.\GodotProjectConcatenator.ps1 -OutputMode "summary" -MaxChunkSize 1MB -FocusPath "scripts"
```

#### Available Parameters

- `-OutputMode`: Type of export to generate
  - `full`: Complete content with automatic chunking
  - `summary`: High-level overview
  - `incremental`: Focus on recent changes
- `-MaxChunkSize`: Maximum size for content chunks (default: 500KB)
- `-FocusPath`: Specific directory to focus on
- `-IncludeStats`: Include detailed statistics (default: true)

## Output Files

### 1. Project Structure
```
project_structure_[date].txt
```
Contains:
- Directory hierarchy
- File listings
- Basic organization

### 2. Project Summary
```
project_summary_[date].txt
```
Includes:
- Total file counts
- Size statistics
- Category breakdowns
- Recent changes
- Extension analysis

### 3. Export Manifest
```
export_manifest.json
```
Provides:
- Machine-readable data
- Complete project metadata
- Category details
- File statistics

## Categories

The script organizes files into these categories:

1. **Core**
   - project.godot
   - .csproj files
   - Solution files

2. **Scripts**
   - C# (.cs)
   - GDScript (.gd)

3. **Scenes**
   - Scene files (.tscn)

4. **Resources**
   - Resource files (.tres)
   - Shader files

5. **Config**
   - Configuration files
   - Import files

## Best Practices

### For AI Assistance
1. Start with summary mode
2. Use focus paths for specific issues
3. Include relevant context
4. Reference specific chunks

### For Large Projects
1. Adjust chunk size as needed
2. Focus on specific directories
3. Use incremental mode
4. Consider summary first

## Troubleshooting

### Common Issues

1. **Permission Errors**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **Path Too Long**
   - Use shorter output directory
   - Move closer to root

3. **Memory Issues**
   - Reduce chunk size
   - Use focus paths
   - Try summary mode

## Examples

### Get Project Overview
```powershell
.\GodotProjectConcatenator.ps1 -OutputMode "summary"
```

### Focus on Scripts
```powershell
.\GodotProjectConcatenator.ps1 -FocusPath "scripts" -OutputMode "full"
```

### Large Project
```powershell
.\GodotProjectConcatenator.ps1 -MaxChunkSize 2MB -OutputMode "full"
```

## Integration Examples

### With Git
```bash
# Pre-commit hook
powershell.exe -File ./GodotProjectConcatenator.ps1 -OutputMode "summary"
```

### Scheduled Task
```powershell
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "-File GodotProjectConcatenator.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At 9am
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "GodotExport"
```

## Support

If you encounter issues:
1. Check troubleshooting section
2. Review error messages
3. Create an issue on GitHub
4. Include export manifest when reporting bugs
