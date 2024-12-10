# Godot Project Concatenator
A PowerShell script for creating comprehensive exports of Godot projects, optimized for AI assistance and project documentation.

## Overview
This script creates organized exports of Godot projects with smart file management, chunking for large projects, and detailed summaries. It's designed to handle projects of any size while maintaining context and organization.

## Requirements
- PowerShell 5.1 or higher
- Write permissions in the project directory
- Sufficient disk space for exports

## Features
- Multiple export modes
- Smart file chunking
- Project statistics and summaries
- Focused exports for specific directories
- File categorization
- Change tracking
- Binary file handling

## Usage

### Basic Usage
```powershell
.\GodotProjectConcatenator.ps1
```
This will create a full export using default settings.

### Parameters
```powershell
.\GodotProjectConcatenator.ps1 -OutputMode "summary" -MaxChunkSize 1MB -FocusPath "scripts" -IncludeStats $true
```

#### Parameter Details:
- `-OutputMode`: Type of export to generate
  - Valid values: 'full', 'summary', 'incremental'
  - Default: 'full'
- `-MaxChunkSize`: Maximum size for content chunks
  - Valid range: 1KB to 10MB
  - Default: 500KB
- `-FocusPath`: Specific directory to focus on
  - Default: "" (all directories)
- `-IncludeStats`: Include detailed statistics
  - Default: $true

## Output Structure

### Generated Files
1. **Main Structure File** (`project_structure_[date].txt`)
   ```
   Godot Project Export - [date]
   ====================================
   Export Mode: [mode]
   Focus Path: [path]

   Directory Structure:
   -------------------
   [directory tree]
   ```

2. **Summary File** (`project_summary_[date].txt`)
   ```
   Project Summary
   ==============
   Total Files: [count]
   Total Size: [size] KB
   Generated: [date]

   Directory Structure
   ================
   [directory tree]

   Category Summaries
   ================
   [category details]
   ```

3. **Content Chunks** (`chunk_[number].txt`)
   - Contains actual file contents
   - Generated in full mode
   - Size controlled by MaxChunkSize

4. **Manifest** (`export_manifest.json`)
   ```json
   {
     "ExportDate": "[date]",
     "Mode": "[mode]",
     "FocusPath": "[path]",
     "TotalFiles": [count],
     "TotalSize": [size],
     "ChunkCount": [count],
     "Categories": {
       [category details]
     }
   }
   ```

### File Categories
| Category  | File Types |
|-----------|------------|
| Core      | project.godot, .csproj, .sln |
| Scripts   | .cs, .gd |
| Scenes    | .tscn |
| Resources | .tres, .shader |
| Config    | .cfg, .import |

## Examples

### Generate Full Export
```powershell
.\GodotProjectConcatenator.ps1 -OutputMode "full"
```

### Generate Summary Only
```powershell
.\GodotProjectConcatenator.ps1 -OutputMode "summary"
```

### Focus on Specific Directory
```powershell
.\GodotProjectConcatenator.ps1 -FocusPath "scenes/levels"
```

### Custom Chunk Size
```powershell
.\GodotProjectConcatenator.ps1 -MaxChunkSize 1MB
```

## Best Practices

### For AI Assistance
1. Start with the summary file for context
2. Reference specific chunks when discussing code
3. Use focus paths for specific problems
4. Include relevant category information

### For Large Projects
1. Use the summary mode first
2. Focus on specific directories when needed
3. Adjust chunk size based on needs
4. Use incremental mode for updates

## File Handling

### Included Files
```powershell
$includePatterns = @(
    "*.cs",      # C# source files
    "*.tscn",    # Godot scene files
    "*.tres",    # Godot resource files
    "*.gdignore", # Godot ignore files
    "*.import",   # Godot import files
    "*.cfg",      # Configuration files
    "*.gd",      # GDScript files
    "*.csproj",   # C# project files
    "*.sln",      # Solution files
    "project.godot", # Main Godot project file
    "*.shader"    # Shader files
)
```

### Excluded Directories
```powershell
$excludeDirs = @(
    ".godot",     # Godot cache directory
    ".mono",      # Mono compilation directory
    "bin",        # Binary output
    "obj",        # Object files
    ".vs",        # Visual Studio directory
    ".idea",      # Rider IDE directory
    "*.tmp",      # Temporary files
    "node_modules" # Node modules
)
```

## Performance Considerations

### Memory Usage
- Sequential chunk processing
- Individual file reading
- Efficient summary generation

### Optimization Tips
- Use appropriate MaxChunkSize for your system
- Focus on specific directories for large projects
- Use summary mode for initial analysis
- Consider incremental updates for large projects

## Troubleshooting

### Common Issues and Solutions

1. **Script Execution Policy**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **Access Denied Errors**
   - Ensure you have write permissions in the output directory
   - Run PowerShell as administrator if needed
   - Check file locks from other processes

3. **Large Project Handling**
   - Decrease MaxChunkSize if experiencing memory issues
   - Use FocusPath to process specific directories
   - Consider using summary mode first

4. **Missing Files**
   - Verify file patterns in $includePatterns
   - Check exclude directories list
   - Verify FocusPath is correct

### Error Messages and Resolutions

#### "Path too long"
- Use shorter output directory names
- Consider moving project closer to root directory

#### "File in use"
- Close any editors or processes using the files
- Wait for background processes to complete
- Use error handling in script

#### "Out of memory"
- Reduce MaxChunkSize
- Use FocusPath for smaller exports
- Close unnecessary applications

## Customization

### Adding New File Types
Add patterns to $includePatterns:
```powershell
$includePatterns += "*.custom"  # Add custom file type
```

### Custom Categories
Modify $fileCategories:
```powershell
$fileCategories["NewCategory"] = @("*.custom", "*.special")
```

### Output Formatting
Modify string templates in the script for custom output formats.

## Advanced Usage

### Automated Exports
Schedule using Task Scheduler:
```powershell
# Create scheduled task
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "-File GodotProjectConcatenator.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At 9am
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "GodotExport"
```

### Integration Examples

#### With Git Hooks
```bash
# .git/hooks/pre-commit
powershell.exe -File ./GodotProjectConcatenator.ps1 -OutputMode "summary"
```

#### With CI/CD
```yaml
# Azure DevOps example
steps:
- powershell: |
    .\GodotProjectConcatenator.ps1 -OutputMode "full" -IncludeStats $true
  displayName: 'Generate Project Documentation'
```

## Maintenance

### Regular Tasks
1. Update file patterns for new Godot versions
2. Review and adjust exclusion patterns
3. Update category definitions
4. Check and optimize chunk sizes

### Version Control
- Keep exported files in .gitignore
- Version control the script itself
- Document changes in script header

## Security Considerations

### File Access
- Script only reads project files
- Writes to specified output directory
- No network access required

### Best Practices
- Review files before sharing
- Remove sensitive information
- Use appropriate permissions

## Support and Updates

### Getting Help
1. Check troubleshooting section
2. Review error messages
3. Verify PowerShell version
4. Check Godot project structure

### Updates
- Check for script updates
- Review Godot version compatibility
- Update patterns as needed

## References

### PowerShell Documentation
- [PowerShell Scripting Guide](https://docs.microsoft.com/en-us/powershell/)
- [File System Commands](https://docs.microsoft.com/en-us/powershell/scripting/samples/working-with-files-folders)

### Godot Documentation
- [Godot Project Structure](https://docs.godotengine.org/en/stable/tutorials/project_workflow/project_organization.html)
- [File Formats](https://docs.godotengine.org/en/stable/development/file_formats/)