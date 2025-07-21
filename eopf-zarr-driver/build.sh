#!/bin/bash

# Build script for EOPF-Zarr Driver Container
# This script builds the Docker image for the EOPF-Zarr GDAL driver

set -e

echo "🐳 Building EOPF-Zarr Driver Container..."

# Build the Docker image
docker build \
    -f eopf-zarr-driver.dockerfile \
    -t eopf-zarr-driver:latest \
    --build-arg BUILDKIT_INLINE_CACHE=1 \
    .

echo "✅ Build completed successfully!"
echo "🚀 To run the container:"
echo "   docker run -p 8888:8888 eopf-zarr-driver:latest"
echo "   or"
echo "   docker-compose up"
echo ""
echo "📖 Access JupyterLab at: http://localhost:8888"
