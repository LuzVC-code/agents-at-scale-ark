#!/bin/bash

# ARK Sequence Diagrams Generator
# Automated PlantUML diagram generation with file monitoring
# Generates SVG and PNG formats with integrated automation

set -euo pipefail

# Configuration
SOURCE_DIR="generate-sequence-diagrams"
OUTPUT_DIR="."
PLANTUML_JAR="plantuml.jar"
PLANTUML_URL="https://github.com/plantuml/plantuml/releases/download/v1.2024.8/plantuml-1.2024.8.jar"

# ANSI color codes for output formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper function for colored output
log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}❌${NC} $1"; }
log_progress() { echo -e "${PURPLE}🔄${NC} $1"; }

# Diagram configuration with metadata
declare -A DIAGRAMS=(
    # Tier 1 Diagrams (Core Functionality)
    ["basic-query-execution"]="Basic Query Execution Flow"
    ["agent-execution-flow"]="Agent Execution Flow"
    ["tool-execution-flow"]="Tool Execution Flow"
    ["team-sequential-strategy"]="Team Sequential Strategy"
    ["memory-service-operations"]="Memory Service Operations"
    
    # Tier 2 Diagrams (Advanced Features)
    ["external-execution-engine-langchain"]="External Execution Engine (LangChain)"
    ["crd-lifecycle-management"]="CRD Lifecycle Management"
    ["team-round-robin-strategy"]="Team Round-Robin Strategy"
    ["mcpserver-to-tools"]="MCPServer to Tools"
    ["event-recording-tracking"]="Event Recording & Tracking"
)

# Function to check and install PlantUML
setup_plantuml() {
    log_info "Checking PlantUML installation..."
    
    # Check if PlantUML is available via command line
    if command -v plantuml >/dev/null 2>&1; then
        log_success "PlantUML found in PATH"
        return 0
    fi
    
    # Check if PlantUML jar exists locally
    if [[ -f "$PLANTUML_JAR" ]]; then
        log_success "PlantUML JAR found locally"
        return 0
    fi
    
    # Try to install via Homebrew (macOS)
    if command -v brew >/dev/null 2>&1; then
        log_progress "Installing PlantUML via Homebrew..."
        brew install plantuml
        return 0
    fi
    
    # Download PlantUML JAR as fallback
    log_progress "Downloading PlantUML JAR..."
    curl -L -o "$PLANTUML_JAR" "$PLANTUML_URL"
    log_success "PlantUML JAR downloaded"
}

# Function to generate diagram
generate_diagram() {
    local diagram_name="$1"
    local description="$2"
    local source_file="$SOURCE_DIR/${diagram_name}.puml"
    local svg_file="$OUTPUT_DIR/${diagram_name}.svg"
    local png_file="$OUTPUT_DIR/${diagram_name}.png"
    
    if [[ ! -f "$source_file" ]]; then
        log_error "Source file not found: $source_file"
        return 1
    fi
    
    log_progress "Generating $description..."
    
    # Generate SVG
    if command -v plantuml >/dev/null 2>&1; then
        plantuml -tsvg -o "../$OUTPUT_DIR" "$source_file"
        plantuml -tpng -o "../$OUTPUT_DIR" "$source_file"
    else
        java -jar "$PLANTUML_JAR" -tsvg -o "../$OUTPUT_DIR" "$source_file"
        java -jar "$PLANTUML_JAR" -tpng -o "../$OUTPUT_DIR" "$source_file"
    fi
    
    if [[ -f "$svg_file" && -f "$png_file" ]]; then
        log_success "Generated: $description (SVG + PNG)"
        return 0
    else
        log_error "Failed to generate: $description"
        return 1
    fi
}

# Function to generate all diagrams
generate_all_diagrams() {
    local success_count=0
    local total_count=${#DIAGRAMS[@]}
    
    log_info "Generating $total_count ARK sequence diagrams..."
    echo
    
    for diagram_name in "${!DIAGRAMS[@]}"; do
        if generate_diagram "$diagram_name" "${DIAGRAMS[$diagram_name]}"; then
            ((success_count++))
        fi
    done
    
    echo
    log_info "Generation Summary:"
    echo "  📊 Total diagrams: $total_count"
    echo "  ✅ Successfully generated: $success_count"
    echo "  ❌ Failed: $((total_count - success_count))"
    
    if [[ $success_count -eq $total_count ]]; then
        log_success "All diagrams generated successfully!"
        return 0
    else
        log_warning "Some diagrams failed to generate"
        return 1
    fi
}

# Function to list available diagrams
list_diagrams() {
    log_info "Available ARK Sequence Diagrams:"
    echo
    echo "🎯 Tier 1 (Core Functionality):"
    for diagram_name in "basic-query-execution" "agent-execution-flow" "tool-execution-flow" "team-sequential-strategy" "memory-service-operations"; do
        if [[ -n "${DIAGRAMS[$diagram_name]:-}" ]]; then
            echo "  • $diagram_name: ${DIAGRAMS[$diagram_name]}"
        fi
    done
    
    echo
    echo "🚀 Tier 2 (Advanced Features):"
    for diagram_name in "external-execution-engine-langchain" "crd-lifecycle-management" "team-round-robin-strategy" "mcpserver-to-tools" "event-recording-tracking"; do
        if [[ -n "${DIAGRAMS[$diagram_name]:-}" ]]; then
            echo "  • $diagram_name: ${DIAGRAMS[$diagram_name]}"
        fi
    done
}

# Function to clean up generated files
cleanup_files() {
    log_warning "Cleaning up generated diagram files..."
    
    for diagram_name in "${!DIAGRAMS[@]}"; do
        rm -f "$OUTPUT_DIR/${diagram_name}.svg"
        rm -f "$OUTPUT_DIR/${diagram_name}.png"
    done
    
    log_success "Cleanup completed"
}

# Function to validate source files
validate_sources() {
    log_info "Validating source files..."
    local missing_count=0
    
    for diagram_name in "${!DIAGRAMS[@]}"; do
        local source_file="$SOURCE_DIR/${diagram_name}.puml"
        if [[ ! -f "$source_file" ]]; then
            log_error "Missing source file: $source_file"
            ((missing_count++))
        fi
    done
    
    if [[ $missing_count -eq 0 ]]; then
        log_success "All source files present"
        return 0
    else
        log_error "$missing_count source files missing"
        return 1
    fi
}

# Function to show file watching mode
watch_mode() {
    log_info "Starting file watch mode..."
    log_info "Monitoring changes in: $SOURCE_DIR"
    log_warning "Press Ctrl+C to stop watching"
    
    if command -v fswatch >/dev/null 2>&1; then
        # Use fswatch if available (better option)
        fswatch -o "$SOURCE_DIR" | while read -r num; do
            log_info "Changes detected, regenerating diagrams..."
            generate_all_diagrams
            echo
            log_info "Waiting for changes..."
        done
    else
        # Fallback to basic monitoring
        log_warning "fswatch not found, using basic monitoring"
        local last_check=$(date +%s)
        
        while true; do
            local current_time=$(date +%s)
            local changes_detected=false
            
            for diagram_name in "${!DIAGRAMS[@]}"; do
                local source_file="$SOURCE_DIR/${diagram_name}.puml"
                if [[ -f "$source_file" ]]; then
                    local file_time=$(stat -c %Y "$source_file" 2>/dev/null || stat -f %m "$source_file")
                    if [[ $file_time -gt $last_check ]]; then
                        changes_detected=true
                        break
                    fi
                fi
            done
            
            if [[ "$changes_detected" == true ]]; then
                log_info "Changes detected, regenerating diagrams..."
                generate_all_diagrams
                echo
                log_info "Waiting for changes..."
                last_check=$current_time
            fi
            
            sleep 2
        done
    fi
}

# Function to show usage
show_usage() {
    echo "ARK Sequence Diagrams Generator"
    echo "Automated PlantUML diagram generation system"
    echo
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo
    echo "Commands:"
    echo "  generate [DIAGRAM]    Generate diagrams (all if no diagram specified)"
    echo "  list                  List all available diagrams"
    echo "  watch                 Watch for file changes and auto-regenerate"
    echo "  clean                 Remove all generated files"
    echo "  validate              Validate source files exist"
    echo "  setup                 Setup PlantUML dependencies"
    echo "  help                  Show this help message"
    echo
    echo "Examples:"
    echo "  $0 generate                           # Generate all diagrams"
    echo "  $0 generate basic-query-execution     # Generate specific diagram"
    echo "  $0 watch                              # Start file monitoring"
    echo "  $0 list                               # Show available diagrams"
    echo
    echo "Output:"
    echo "  SVG files: Generated in $OUTPUT_DIR/"
    echo "  PNG files: Generated in $OUTPUT_DIR/"
    echo "  Source:    Located in $SOURCE_DIR/"
}

# Main script logic
main() {
    local command="${1:-generate}"
    
    case "$command" in
        "generate")
            setup_plantuml
            if [[ -n "${2:-}" ]]; then
                # Generate specific diagram
                local diagram_name="$2"
                if [[ -n "${DIAGRAMS[$diagram_name]:-}" ]]; then
                    generate_diagram "$diagram_name" "${DIAGRAMS[$diagram_name]}"
                else
                    log_error "Unknown diagram: $diagram_name"
                    log_info "Run '$0 list' to see available diagrams"
                    exit 1
                fi
            else
                # Generate all diagrams
                validate_sources
                generate_all_diagrams
            fi
            ;;
        "list")
            list_diagrams
            ;;
        "watch")
            setup_plantuml
            validate_sources
            watch_mode
            ;;
        "clean")
            cleanup_files
            ;;
        "validate")
            validate_sources
            ;;
        "setup")
            setup_plantuml
            ;;
        "help"|"-h"|"--help")
            show_usage
            ;;
        *)
            log_error "Unknown command: $command"
            echo
            show_usage
            exit 1
            ;;
    esac
}

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Run main function with all arguments
main "$@"
