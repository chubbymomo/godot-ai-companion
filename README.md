# godot-ai-companion

A powerful tool designed to help Godot developers effectively leverage AI assistance by creating comprehensive, well-organized exports of their projects.

## Features

- 📊 Smart project analysis and organization
- 📁 Automatic file categorization
- 📈 Detailed project statistics
- 🔄 Multiple export modes
- 📦 Large project handling

## Quick Start

1. Clone the repository:
```powershell
git clone https://github.com/yourusername/godot-ai-companion.git
```

2. Navigate to the source directory:
```powershell
cd godot-ai-companion/src
```

3. Run in your Godot project directory:
```powershell
.\GodotProjectConcatenator.ps1
```

## Usage

### Basic Usage
```powershell
.\GodotProjectConcatenator.ps1
```

### Export Modes

1. Full Export:
```powershell
.\GodotProjectConcatenator.ps1 -OutputMode "full"
```

2. Summary Only:
```powershell
.\GodotProjectConcatenator.ps1 -OutputMode "summary"
```

3. Focus on Directory:
```powershell
.\GodotProjectConcatenator.ps1 -FocusPath "scenes/levels"
```

## Requirements

- PowerShell 5.1 or higher
- Write permissions in project directory
- Sufficient disk space for exports

## Output Structure

The script generates several files:

1. Project Structure (`project_structure_[date].txt`)
   - Directory hierarchy
   - Basic file organization

2. Project Summary (`project_summary_[date].txt`)
   - File statistics
   - Category breakdowns
   - Recent changes
   - Extension analysis

3. Export Manifest (`export_manifest.json`)
   - Machine-readable project data
   - Category details
   - File metadata

## Contributing

Contributions are welcome! Please read our [Contributing Guidelines](docs/CONTRIBUTING.md) for details on:
- Code style
- Pull request process
- Documentation standards

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Godot Engine community
- PowerShell community
- All contributors
