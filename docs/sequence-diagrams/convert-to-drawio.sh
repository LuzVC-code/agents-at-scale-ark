#!/bin/bash

# Convert PlantUML diagrams to Draw.io format
# This script converts SVG outputs to Draw.io XML format

OUTPUT_DIR="docs/sequence-diagrams/output"
DRAWIO_DIR="docs/sequence-diagrams/drawio"

# Create drawio directory
mkdir -p "$DRAWIO_DIR"

echo "[INFO] Converting PlantUML diagrams to Draw.io format..."

# Function to convert SVG to Draw.io XML
convert_svg_to_drawio() {
    local svg_file="$1"
    local base_name=$(basename "$svg_file" .svg)
    local drawio_file="$DRAWIO_DIR/${base_name}.drawio"
    
    echo "[INFO] Converting: $svg_file -> $drawio_file"
    
    # Create a basic Draw.io XML structure with embedded SVG
    cat > "$drawio_file" << EOF
<mxfile host="Electron" modified="$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)" agent="Mozilla/5.0" version="24.7.5" etag="$(uuidgen)" type="device">
  <diagram name="ARK Sequence Diagram" id="ark-sequence">
    <mxGraphModel dx="1422" dy="794" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="827" pageHeight="1169" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <mxCell id="2" value="" style="shape=image;html=1;verticalAlign=top;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;imageAspect=0;aspect=fixed;image=data:image/svg+xml,$(base64 -i "$svg_file" | tr -d '\n')" vertex="1" parent="1">
          <mxGeometry x="40" y="40" width="747" height="1089" as="geometry" />
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
EOF
    
    echo "[SUCCESS] Created: $drawio_file"
}

# Convert all SVG files
for svg_file in "$OUTPUT_DIR"/*.svg; do
    if [ -f "$svg_file" ]; then
        convert_svg_to_drawio "$svg_file"
    fi
done

echo "[SUCCESS] Draw.io conversion completed!"
echo "[INFO] Files available in: $DRAWIO_DIR"
echo ""
echo "To use these files:"
echo "1. Open Draw.io (app.diagrams.net)"
echo "2. File -> Open From -> Device"
echo "3. Select any .drawio file"
echo "4. Edit as needed"
echo "5. Export in desired format"
