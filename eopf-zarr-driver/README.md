# EOPF-Zarr GDAL Driver Container

A simplified Docker container with EOPF-Zarr GDAL driver support, built on Jupyter's minimal-notebook for optimal JupyterHub compatibility.

## Quick Start

### Build Locally
```bash
docker build -t eopf-zarr-driver ./eopf-zarr-driver
```

### Test Locally
```bash
docker run --rm -p 8888:8888 eopf-zarr-driver
```

### Push to Your Registry
```bash
docker tag eopf-zarr-driver your-registry/eopf-zarr-driver:latest
docker push your-registry/eopf-zarr-driver:latest
```

## Features

- **Jupyter Base**: Built on `quay.io/jupyter/minimal-notebook` for seamless JupyterHub integration
- **GDAL Support**: System GDAL with EOPF-Zarr driver
- **Rasterio Compatibility**: Compiled against system GDAL for plugin detection
- **Essential Packages**: Includes xarray, zarr, dask, geopandas, and geospatial tools
- **Optimized Build**: Single-platform, minimal dependencies for fast builds

## Architecture

### Base Image
- Uses `jupyter/minimal-notebook` instead of building from scratch
- Inherits JupyterHub compatibility and user management
- Reduces build time and complexity

### EOPF-Zarr Driver
- Compiled from [GDAL-ZARR-EOPF](https://github.com/EOPF-Sample-Service/GDAL-ZARR-EOPF)
- Installed to `/opt/eopf-zarr/drivers/`
- Accessible via GDAL and rasterio

### Python Environment
- GDAL Python bindings matching system GDAL version
- Rasterio compiled from source for compatibility
- Core geospatial packages: xarray, zarr, dask, geopandas

## Usage in JupyterHub

This container is designed for direct use in JupyterHub environments:

1. **Build** the image locally or via CI
2. **Push** to your container registry
3. **Configure** JupyterHub to use the image
4. **Test** EOPF-Zarr functionality in notebooks

## Testing EOPF-Zarr Driver

```python
# Test GDAL driver
from osgeo import gdal
driver = gdal.GetDriverByName('EOPFZARR')
print(f"EOPF-Zarr driver: {driver.GetDescription()}")

# Test with rasterio
import rasterio
url = 'EOPFZARR:"/vsicurl/https://your-zarr-url"'
with rasterio.open(url) as src:
    print(f"Shape: {src.shape}, CRS: {src.crs}")
```

## Simplified Workflow

This container follows the principle of simplicity:
- **No complex CI/CD**: Build locally, test locally, push when ready
- **No vulnerability scanning**: Harbor registry handles security scans
- **No docker-compose**: Direct container usage in JupyterHub
- **No custom entrypoints**: Jupyter base image handles everything
