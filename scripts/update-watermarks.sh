#!/bin/bash
# Update watermarks in sequence diagram documentation

set -e

echo "🏷️ Updating sequence diagram watermarks..."

# Get current version and date
VERSION=$(cat version.txt | tr -d '\n')
CURRENT_DATE=$(date +"%Y-%m-%d")
CURRENT_DATE_FORMATTED=$(date +"%B %-d, %Y")

echo "📋 Using version: v$VERSION"
echo "📅 Using date: $CURRENT_DATE_FORMATTED"

# Update or add version in all MDX files
for file in docs/content/developer-guide/Diagrams/Sequence-Diagrams/*.mdx; do
    if [ -f "$file" ]; then
        echo "Processing: $(basename "$file")"
        
        # Check if version line already exists
        if grep -q "^Version: v" "$file"; then
            # Update existing version
            sed -i.bak "s/^Version: v[0-9.]*/Version: v$VERSION/" "$file"
        else
            # Add version before the last line if it doesn't exist
            # Find the last paragraph and add version after it
            if grep -q "This comprehensive.*" "$file"; then
                # Add version after the "This comprehensive..." paragraph
                sed -i.bak "/This comprehensive.*\./a\\
\\
Version: v$VERSION" "$file"
            else
                # Fallback: add at the end of the file
                echo "" >> "$file"
                echo "Version: v$VERSION" >> "$file"
            fi
        fi
        
        # Update date in "Last updated on..." if it exists
        sed -i.bak "s/Last updated on [A-Za-z0-9, ]*/Last updated on $CURRENT_DATE_FORMATTED/g" "$file"
    fi
done

# Remove backup files
find docs/content/developer-guide/Diagrams/Sequence-Diagrams/ -name "*.bak" -delete

echo "✅ Updated watermarks in sequence diagrams:"
find docs/content/developer-guide/Diagrams/Sequence-Diagrams/ -name "*.mdx" -exec basename {} \; | sed 's/^/  - /'

echo ""
echo "💡 Tip: Run 'git diff' to see the changes"
