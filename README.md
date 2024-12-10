# godot-ai-companion# Godot AI Companion

A powerful tool designed to help Godot developers leverage AI assistance by intelligently exporting and organizing their project files. This tool creates AI-friendly documentation of your Godot project, making it easier to get meaningful help from AI assistants.

## Features

- 📁 Smart project organization and chunking
- 📊 Detailed project statistics and summaries
- 🎯 Focused exports for specific directories
- 📝 Comprehensive file categorization
- 🔄 Incremental updates support
- 🛡️ Binary file handling
- 📈 Memory-efficient processing

## Quick Start

1. Clone the repository:
```powershell
git clone https://github.com/yourusername/godot-ai-companion.git
```

2. Navigate to the src directory:
```powershell
cd godot-ai-companion/src
```

3. Run the script in your Godot project directory:
```powershell
.\GodotProjectConcatenator.ps1
```

## Requirements

- PowerShell 5.1 or higher
- Write permissions in your Godot project directory
- Sufficient disk space for exports

## Usage

### Basic Usage
```powershell
.\GodotProjectConcatenator.ps1
```

### Advanced Options
```powershell
.\GodotProjectConcatenator.ps1 -OutputMode "summary" -MaxChunkSize 1MB -FocusPath "scripts"
```

### Parameters

- `-OutputMode`: Type of export ('full', 'summary', 'incremental')
- `-MaxChunkSize`: Maximum chunk size (1KB to 10MB)
- `-FocusPath`: Specific directory to focus on
- `-IncludeStats`: Include detailed statistics

## Output Structure

The script generates several files:

1. Main structure file (`project_structure_[date].txt`)
2. Summary file (`project_summary_[date].txt`)
3. Content chunks (`chunk_[number].txt`)
4. Export manifest (`export_manifest.json`)

## Best Practices

### For AI Assistance
- Start with the summary file for context
- Reference specific chunks when discussing code
- Use focus paths for specific problems
- Include relevant category information

### For Large Projects
- Use summary mode first
- Focus on specific directories when needed
- Adjust chunk size based on needs
- Use incremental mode for updates

## Contributing

Contributions are welcome! Please read our [Contributing Guidelines](docs/CONTRIBUTING.md) for details on how to submit pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Godot Engine community
- PowerShell community
- All contributors and users

## Support

If you encounter any issues or have questions, please:
1. Check the [documentation](docs/README.md)
2. Search existing issues
3. Create a new issue if needed

## Roadmap

- [ ] Add support for custom file types
- [ ] Implement diff-based incremental updates
- [ ] Add configuration file support
- [ ] Create GUI interface
- [ ] Add direct AI integration options

## Related Projects

- [Godot Engine](https://godotengine.org/)
- [Godot C# Tools](https://docs.godotengine.org/en/stable/tutorials/scripting/c_sharp/index.html)