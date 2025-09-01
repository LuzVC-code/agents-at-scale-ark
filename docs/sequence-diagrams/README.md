# ARK Sequence Diagrams

Comprehensive sequence diagrams for the ARK (Agents at Scale) platform, automatically generated using PlantUML with integrated monitoring and multi-format output.

## Available Diagrams

### Tier 1 (Core Functionality)
- **basic-query-execution**: Complete query processing workflow from initiation to completion
- **agent-execution-flow**: Agent lifecycle, model interactions, and execution patterns  
- **tool-execution-flow**: Tool registry, execution, and result processing
- **team-sequential-strategy**: Sequential team member coordination and message passing
- **memory-service-operations**: Memory service integration and data persistence

### Tier 2 (Advanced Features)  
- **external-execution-engine-langchain**: LangChain integration with RAG and custom chains
- **crd-lifecycle-management**: Kubernetes CRD operations, webhooks, and controller patterns
- **team-round-robin-strategy**: Round-robin team execution with turn management
- **mcpserver-to-tools**: Model Context Protocol server integration and tool discovery
- **event-recording-tracking**: Comprehensive observability and telemetry system

## Automated Generation System

### Quick Start
```bash
# Generate all diagrams
./update-query-diagrams.sh generate

# Generate specific diagram
./update-query-diagrams.sh generate basic-query-execution

# Start file monitoring (auto-regenerate on changes)
./update-query-diagrams.sh watch

# List all available diagrams
./update-query-diagrams.sh list
```

### System Features
- **Multi-Format Output**: SVG and PNG generation
- **File Monitoring**: Automatic regeneration on source changes
- **Dependency Management**: Automated PlantUML installation
- **Validation**: Source file verification and error handling
- **Cleanup Tools**: Generated file management

## Directory Structure

```
docs/sequence-diagrams/
├── generate-sequence-diagrams/     # PlantUML source files (.puml)
│   ├── basic-query-execution.puml
│   ├── agent-execution-flow.puml
│   ├── tool-execution-flow.puml
│   ├── team-sequential-strategy.puml
│   ├── memory-service-operations.puml
│   ├── external-execution-engine-langchain.puml
│   ├── crd-lifecycle-management.puml
│   ├── team-round-robin-strategy.puml
│   ├── mcpserver-to-tools.puml
│   └── event-recording-tracking.puml
├── output/                         # Generated files organized by diagram
│   ├── basic-query-execution/
│   │   ├── basic-query-execution.svg
│   │   ├── basic-query-execution.png
│   │   └── basic-query-execution.drawio
│   ├── agent-execution-flow/
│   │   ├── agent-execution-flow.svg
│   │   ├── agent-execution-flow.png
│   │   └── agent-execution-flow.drawio
│   ├── tool-execution-flow/
│   │   ├── tool-execution-flow.svg
│   │   ├── tool-execution-flow.png
│   │   └── tool-execution-flow.drawio
│   ├── team-sequential-strategy/
│   │   ├── team-sequential-strategy.svg
│   │   ├── team-sequential-strategy.png
│   │   └── team-sequential-strategy.drawio
│   ├── memory-service-operations/
│   │   ├── memory-service-operations.svg
│   │   ├── memory-service-operations.png
│   │   └── memory-service-operations.drawio
│   ├── external-execution-engine-langchain/
│   │   ├── external-execution-engine-langchain.svg
│   │   ├── external-execution-engine-langchain.png
│   │   └── external-execution-engine-langchain.drawio
│   ├── crd-lifecycle-management/
│   │   ├── crd-lifecycle-management.svg
│   │   ├── crd-lifecycle-management.png
│   │   └── crd-lifecycle-management.drawio
│   ├── team-round-robin-strategy/
│   │   ├── team-round-robin-strategy.svg
│   │   ├── team-round-robin-strategy.png
│   │   └── team-round-robin-strategy.drawio
│   ├── mcpserver-to-tools/
│   │   ├── mcpserver-to-tools.svg
│   │   ├── mcpserver-to-tools.png
│   │   └── mcpserver-to-tools.drawio
│   └── event-recording-tracking/
│       ├── event-recording-tracking.svg
│       ├── event-recording-tracking.png
│       └── event-recording-tracking.drawio
├── update-query-diagrams.sh       # Automation script
├── convert-to-drawio.sh           # Draw.io format converter
├── README.md                      # This file
├── IMPLEMENTATION_SUMMARY.md      # Technical implementation details
└── .gitignore                     # Ignore generated files
```

## Usage Examples

### Generate All Diagrams
```bash
./update-query-diagrams.sh generate
```

### Watch Mode (Development)
```bash
./update-query-diagrams.sh watch
# Monitors generate-sequence-diagrams/ for changes
# Auto-regenerates on file modifications
```

### List Available Diagrams
```bash
./update-query-diagrams.sh list
```

### Validate Source Files
```bash
./update-query-diagrams.sh validate
```

### Clean Generated Files
```bash
./update-query-diagrams.sh clean
```

## Prerequisites

### macOS (Recommended)
```bash
# Install via Homebrew (automatically handled by script)
brew install plantuml

# Optional: File monitoring (improved watch mode)
brew install fswatch
```

### Manual Installation
```bash
# Download PlantUML JAR (handled automatically if needed)
curl -L -o plantuml.jar https://github.com/plantuml/plantuml/releases/download/v1.2024.8/plantuml-1.2024.8.jar
```

## Advanced Usage

### Custom Output Directory
```bash
# Modify OUTPUT_DIR in script for custom location
OUTPUT_DIR="custom/output/path"
```

### Integration with CI/CD
```bash
# Add to GitHub Actions, GitLab CI, etc.
- name: Generate Diagrams
  run: |
    cd docs/sequence-diagrams
    ./update-query-diagrams.sh generate
    ./convert-to-drawio.sh  # Optional: Draw.io format
```

### Development Workflow
```bash
# 1. Start monitoring
./update-query-diagrams.sh watch

# 2. Edit source files in generate-sequence-diagrams/
# 3. Diagrams auto-regenerate on save

# 4. Commit changes
git add generate-sequence-diagrams/
git commit -m "Update sequence diagrams"
```

## Output Formats

### SVG (Vector Graphics)
- Scalable vector format
- Web-friendly
- High quality at any resolution
- Generated as: `{diagram-name}.svg`

### PNG (Raster Graphics)  
- Standard image format
- Documentation embedding
- Presentation usage
- Generated as: `{diagram-name}.png`

### Draw.io (Optional)
```bash
# Convert to Draw.io format
./convert-to-drawio.sh
```

## Integration

### VS Code Extension
Recommended extensions for development:
- PlantUML (jebbs.plantuml)
- Markdown Preview Enhanced
- Draw.io Integration

### Documentation Embedding
```markdown
# In documentation files
![Basic Query Execution](sequence-diagrams/basic-query-execution.svg)
```

### Presentation Usage
- Use PNG format for slides
- SVG format for web documentation
- Draw.io format for collaborative editing

## Troubleshooting

### PlantUML Not Found
```bash
# Install via Homebrew
brew install plantuml

# Or download JAR manually
curl -L -o plantuml.jar https://github.com/plantuml/plantuml/releases/download/v1.2024.8/plantuml-1.2024.8.jar
```

### File Watch Issues
```bash
# Install fswatch for better monitoring
brew install fswatch

# Or use basic polling mode (automatic fallback)
```

### Generation Failures
```bash
# Validate source files
./update-query-diagrams.sh validate

# Check PlantUML syntax
plantuml -syntax generate-sequence-diagrams/diagram-name.puml
```

## Version Information

- **ARK Platform**: v0.1.31
- **PlantUML**: v1.2024.8
- **Diagram Count**: 10 (5 Tier 1 + 5 Tier 2)
- **Output Formats**: SVG, PNG, Draw.io (optional)
- **Last Updated**: September 2025

## Contributing

### Adding New Diagrams
1. Create `.puml` file in `generate-sequence-diagrams/`
2. Add entry to `DIAGRAMS` array in script
3. Test generation: `./update-query-diagrams.sh generate new-diagram-name`
4. Update README.md with diagram description

### Modifying Existing Diagrams
1. Edit source `.puml` file
2. Use watch mode for real-time updates
3. Verify output in both SVG and PNG formats
4. Commit source changes (generated files are gitignored)

For detailed implementation information, see [IMPLEMENTATION_SUMMARY.md](./IMPLEMENTATION_SUMMARY.md).
