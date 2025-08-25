#!/bin/bash

# Script to regenerate spice-client from OpenAPI specification
# This updates the spice_client/ folder from the spice-api.json file

set -e

# Check if we're in the right directory
if [ ! -f "pyproject.toml" ] || [ ! -d "spice_client" ]; then
    echo "Error: Please run this script from the spice-client directory"
    exit 1
fi

# Check if spice-api.json exists
if [ ! -f "spice-api.json" ]; then
    echo "Error: spice-api.json not found at spice-api.json"
    echo "Please ensure the OpenAPI specification is available"
    exit 1
fi

echo "🔄 Regenerating SPICE client from OpenAPI specification..."

# Remove old generated files (preserve custom helpers)
echo "📁 Backing up helpers directory..."
cp -r helpers helpers.backup

echo "🗑️  Removing old generated files..."
rm -rf spice_client

echo "🔧 Generating new client code..."
openapi-generator-cli generate \
  -i spice-api.json \
  -g python \
  -o ./temp_client \
  --additional-properties=packageName=spice_client,projectName=spice-client,packageVersion=0.1.0

# Move the generated spice_client folder
mv temp_client/spice_client ./

# Clean up temporary directory
rm -rf temp_client

echo "📁 Restoring helpers directory..."
rm -rf helpers
mv helpers.backup helpers

echo "✅ Client regeneration complete!"
echo "📋 Generated files are in the spice_client/ directory"
echo "🔍 You may want to review any changes before committing"