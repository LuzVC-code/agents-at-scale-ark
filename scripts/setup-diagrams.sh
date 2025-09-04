#!/bin/bash
# Setup script for diagram automation

set -e

echo "🔧 Setting up sequence diagram automation..."

# Make scripts executable
chmod +x .githooks/pre-commit

# Setup git hooks
if [ -d ".git" ]; then
    echo "📁 Setting up git hooks..."
    ln -sf ../../.githooks/pre-commit .git/hooks/pre-commit
    echo "✅ Pre-commit hook installed"
fi

# Check dependencies
echo "🔍 Checking dependencies..."

if ! command -v java >/dev/null 2>&1; then
    echo "❌ Java not found. Please install Java 11 or later for PlantUML"
    exit 1
fi

if ! command -v make >/dev/null 2>&1; then
    echo "❌ Make not found. Please install make"
    exit 1
fi

# Download PlantUML if not present
if [ ! -f "plantuml.jar" ]; then
    echo "📥 Downloading PlantUML..."
    curl -L -o plantuml.jar https://github.com/plantuml/plantuml/releases/download/v1.2024.8/plantuml-1.2024.8.jar
    echo "✅ PlantUML downloaded"
fi

# Initial diagram generation
echo "🔄 Generating initial diagrams..."
make -f docs/Makefile.diagrams update-diagrams

echo "✅ Setup complete!"
echo ""
echo "📖 Usage:"
echo "  make -f docs/Makefile.diagrams update-diagrams  # Update all diagrams"
echo "  make -f docs/Makefile.diagrams watch-diagrams   # Watch for changes"
echo ""
echo "🔄 The following will trigger automatic updates:"
echo "  - Git commits with .puml file changes (pre-commit hook)"
echo "  - GitHub pushes to main/develop branches (GitHub Actions)"
echo "  - Manual execution of make targets"
