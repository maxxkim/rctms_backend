#!/bin/bash

# Phoenix Project Knowledge Collector
# This script collects and minifies crucial files from a Phoenix/Elixir project
# for documentation and knowledge sharing purposes

# Configuration
OUTPUT_FILE="project_knowledge.md"
TEMP_DIR=$(mktemp -d)
PROJECT_ROOT="."  # Change this to your project root if needed

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check for required tools
echo -e "${YELLOW}Checking requirements...${NC}"
for cmd in elixir mix find grep sed; do
  if ! command_exists "$cmd"; then
    echo -e "${RED}Error: $cmd is not installed or not in PATH${NC}"
    exit 1
  fi
done

# Create output file with header
cat > "$OUTPUT_FILE" << EOF
# Project Knowledge Base
Generated on $(date)

## Table of Contents
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Database Schema](#database-schema)
- [Controllers](#controllers)
- [Models](#models)
- [LiveView Components](#liveview-components)
- [GraphQL Schema](#graphql-schema)
- [Channels](#channels)
- [GenServers and Supervisors](#genservers-and-supervisors)
- [Tests](#tests)

EOF

echo -e "${GREEN}Collecting project information...${NC}"

# Get project structure
echo "## Project Structure" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
find "$PROJECT_ROOT" -type f -name "*.ex" -o -name "*.exs" -o -name "*.heex" | grep -v "_build\|deps\|node_modules" | sort >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Get mix.exs for dependencies
echo "## Configuration" >> "$OUTPUT_FILE"
echo "### mix.exs" >> "$OUTPUT_FILE"
echo '```elixir' >> "$OUTPUT_FILE"
if [ -f "$PROJECT_ROOT/mix.exs" ]; then
  cat "$PROJECT_ROOT/mix.exs" >> "$OUTPUT_FILE"
else
  echo "# mix.exs file not found" >> "$OUTPUT_FILE"
fi
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Get config files
echo "### Configuration Files" >> "$OUTPUT_FILE"
for config_file in "$PROJECT_ROOT/config/config.exs" "$PROJECT_ROOT/config/dev.exs" "$PROJECT_ROOT/config/prod.exs" "$PROJECT_ROOT/config/runtime.exs"; do
  if [ -f "$config_file" ]; then
    echo "#### $(basename "$config_file")" >> "$OUTPUT_FILE"
    echo '```elixir' >> "$OUTPUT_FILE"
    cat "$config_file" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
  fi
done

# Get database migrations
echo "## Database Schema" >> "$OUTPUT_FILE"
echo "### Migrations" >> "$OUTPUT_FILE"
migration_files=$(find "$PROJECT_ROOT/priv/repo/migrations" -type f -name "*.exs" 2>/dev/null | sort)
if [ -n "$migration_files" ]; then
  for migration in $migration_files; do
    echo "#### $(basename "$migration")" >> "$OUTPUT_FILE"
    echo '```elixir' >> "$OUTPUT_FILE"
    cat "$migration" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
  done
else
  echo "No migration files found." >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# Get schema files
echo "### Schema Files" >> "$OUTPUT_FILE"
schema_files=$(find "$PROJECT_ROOT/lib" -type f -name "*.ex" | grep -E '/(schema|schemas)/' 2>/dev/null)
if [ -z "$schema_files" ]; then
  # Try alternate locations
  schema_files=$(find "$PROJECT_ROOT/lib" -type f -name "*.ex" | grep -E '/models/' 2>/dev/null)
fi

if [ -n "$schema_files" ]; then
  for schema in $schema_files; do
    echo "#### $(basename "$schema")" >> "$OUTPUT_FILE"
    echo '```elixir' >> "$OUTPUT_FILE"
    cat "$schema" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
  done
else
  echo "No schema files found." >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# Get controllers
echo "## Controllers" >> "$OUTPUT_FILE"
controller_files=$(find "$PROJECT_ROOT/lib" -type f -name "*_controller.ex" 2>/dev/null)
if [ -n "$controller_files" ]; then
  for controller in $controller_files; do
    echo "### $(basename "$controller")" >> "$OUTPUT_FILE"
    echo '```elixir' >> "$OUTPUT_FILE"
    cat "$controller" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
  done
else
  echo "No controller files found." >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# Get context modules
echo "## Context Modules" >> "$OUTPUT_FILE"
context_files=$(find "$PROJECT_ROOT/lib" -type f -name "*.ex" | grep -v "_web" | grep -v "application.ex" | grep -v "repo.ex" 2>/dev/null)
if [ -n "$context_files" ]; then
  for context in $context_files; do
    # Check if file contains "defmodule" and looks like a context
    if grep -q "defmodule" "$context" && grep -q "def " "$context"; then
      echo "### $(basename "$context")" >> "$OUTPUT_FILE"
      echo '```elixir' >> "$OUTPUT_FILE"
      cat "$context" >> "$OUTPUT_FILE"
      echo '```' >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
    fi
  done
else
  echo "No context files found." >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# Get LiveView components
echo "## LiveView Components" >> "$OUTPUT_FILE"
liveview_files=$(find "$PROJECT_ROOT/lib" -type f -name "*_live.ex" 2>/dev/null)
if [ -n "$liveview_files" ]; then
  for liveview in $liveview_files; do
    echo "### $(basename "$liveview")" >> "$OUTPUT_FILE"
    echo '```elixir' >> "$OUTPUT_FILE"
    cat "$liveview" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
  done
else
  echo "No LiveView files found." >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# Get LiveView templates
echo "### LiveView Templates" >> "$OUTPUT_FILE"
template_files=$(find "$PROJECT_ROOT/lib" -type f -name "*.heex" 2>/dev/null)
if [ -n "$template_files" ]; then
  for template in $template_files; do
    echo "#### $(basename "$template")" >> "$OUTPUT_FILE"
    echo '```heex' >> "$OUTPUT_FILE"
    cat "$template" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
  done
else
  echo "No template files found." >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# Get GraphQL schema if exists
echo "## GraphQL Schema" >> "$OUTPUT_FILE"
graphql_files=$(find "$PROJECT_ROOT/lib" -type f -name "*.ex" | grep -E 'schema.ex|types.ex|resolvers.ex' 2>/dev/null)
if [ -n "$graphql_files" ]; then
  for graphql in $graphql_files; do
    echo "### $(basename "$graphql")" >> "$OUTPUT_FILE"
    echo '```elixir' >> "$OUTPUT_FILE"
    cat "$graphql" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
  done
else
  echo "No GraphQL schema files found." >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# Get Phoenix Channels
echo "## Channels" >> "$OUTPUT_FILE"
channel_files=$(find "$PROJECT_ROOT/lib" -type f -name "*_channel.ex" 2>/dev/null)
if [ -n "$channel_files" ]; then
  for channel in $channel_files; do
    echo "### $(basename "$channel")" >> "$OUTPUT_FILE"
    echo '```elixir' >> "$OUTPUT_FILE"
    cat "$channel" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
  done
else
  echo "No channel files found." >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# Get GenServers and Supervisors
echo "## GenServers and Supervisors" >> "$OUTPUT_FILE"
genserver_files=$(find "$PROJECT_ROOT/lib" -type f -name "*.ex" | xargs grep -l "use GenServer\|use Supervisor" 2>/dev/null)
if [ -n "$genserver_files" ]; then
  for genserver in $genserver_files; do
    echo "### $(basename "$genserver")" >> "$OUTPUT_FILE"
    echo '```elixir' >> "$OUTPUT_FILE"
    cat "$genserver" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
  done
else
  echo "No GenServer or Supervisor files found." >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# Get test files
echo "## Tests" >> "$OUTPUT_FILE"
test_files=$(find "$PROJECT_ROOT/test" -type f -name "*_test.exs" | head -n 5 2>/dev/null)
if [ -n "$test_files" ]; then
  for test in $test_files; do
    echo "### $(basename "$test")" >> "$OUTPUT_FILE"
    echo '```elixir' >> "$OUTPUT_FILE"
    cat "$test" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
  done
  echo "Note: Only showing first 5 test files. There may be more." >> "$OUTPUT_FILE"
else
  echo "No test files found." >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# Clean up
rm -rf "$TEMP_DIR"

# Final output
echo -e "${GREEN}Project knowledge has been collected to ${OUTPUT_FILE}${NC}"
echo -e "${YELLOW}Total size: $(du -h "$OUTPUT_FILE" | cut -f1)${NC}"
echo -e "${YELLOW}Total files processed: $(grep -c '```elixir' "$OUTPUT_FILE")${NC}"