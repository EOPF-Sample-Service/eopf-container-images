# EOPF-Zarr Docker Image - Quick Start Guide

## 🚀 Ready-to-Use Docker Image

The EOPF-Zarr GDAL driver is now available as a public Docker image on Docker Hub with JupyterHub compatibility!

```bash
docker pull yuvraj1989/eopf-zarr-driver:v2.1.0-jupyterhub
```

## 🎯 What's Included

- **Ubuntu 25.04** with **GDAL 3.10.2**
- **EOPF-Zarr GDAL driver** built and ready to use
- **Complete rasterio integration** (compiled against system GDAL)
- **JupyterLab environment** with all geospatial packages
- **JupyterHub single-user compatibility** 
- **Network access** for remote Zarr datasets
- **Compression support** (blosc, LZ4, ZSTD)

## 🏃 Quick Start

### Option 1: Using Docker Compose (Recommended)
```bash
# Start the service
docker-compose up -d

# Access JupyterLab at: http://localhost:8888
```

### Option 2: Direct Docker Run
```bash
# Run JupyterLab directly
docker run -p 8888:8888 yuvraj1989/eopf-zarr-driver:v2.1.0-jupyterhub

# Access JupyterLab at: http://localhost:8888
```

### Option 3: Interactive Shell
```bash
# Run interactive shell for testing
docker run -it yuvraj1989/eopf-zarr-driver:v2.1.0-jupyterhub /bin/bash

# Test GDAL driver
gdalinfo --formats | grep EOPF

# Test with a Zarr dataset
gdalinfo "EOPFZARR:'/vsicurl/https://example.com/dataset.zarr'"
```

## 🧪 Testing EOPF-Zarr Functionality

### Test All Functionality
```bash
# Run comprehensive tests
docker run --rm yuvraj1989/eopf-zarr-driver:v2.1.0-jupyterhub python3 /usr/local/bin/test-environment.py
```

### GDAL Integration
```python
from osgeo import gdal

# Open a remote Zarr dataset
url = "EOPFZARR:'/vsicurl/https://storage.sbg.cloud.ovh.net/v1/AUTH_8471d76cdd494d98a078f28b195dace4/sentinel-1-public/demo_product/grd/S01SIWGRH_20240201T164915_0025_A146_S000_5464A_VH.zarr'"
dataset = gdal.Open(url)
print(f"Dataset size: {dataset.RasterXSize} x {dataset.RasterYSize}")
```

### rasterio Integration  
```python
import rasterio

# Same dataset, using rasterio
with rasterio.open(url) as src:
    print(f"Dataset CRS: {src.crs}")
    print(f"Dataset bounds: {src.bounds}")
    data = src.read(1)  # Read first band
```

## 🎯 JupyterHub Compatibility

This image is fully compatible with JupyterHub deployments:

- **User**: `jupyter` (UID: 1000, GID: 100)
- **Environment Variables**: All NB_* variables supported
- **Entry Points**: Compatible with JupyterHub single-user server
- **Permissions**: Proper file ownership and workspace setup

## 🔧 Environment Variables

The image comes pre-configured with:
- `GDAL_DRIVER_PATH=/opt/eopf-zarr/drivers`
- `GDAL_DATA=/usr/share/gdal`
- `PROJ_LIB=/usr/share/proj`
- `PYTHONPATH=/usr/local/lib/python3.13/site-packages`
- `NB_USER=jupyter`, `NB_UID=1000`, `NB_GID=100`

## 📊 Available Packages

- **Core**: gdal, rasterio, xarray, zarr, dask
- **Geospatial**: geopandas, rioxarray, fiona, shapely, pyproj
- **Scientific**: numpy, scipy, matplotlib, netcdf4, h5py
- **Visualization**: cartopy, jupyter ecosystem
- **Compression**: blosc, numcodecs
- **JupyterHub**: jupyterhub, jupyter-server

## 🆕 What's New in v2.1.0-jupyterhub

- ✅ **JupyterHub single-user compatibility** 
- ✅ **Remote Zarr URL access validated**
- ✅ Enhanced user management (jupyter user)
- ✅ Comprehensive testing suite with remote URL tests
- ✅ Production-ready for both standalone and hub deployments

## 🐛 Troubleshooting

### Common Issues

1. **URL Format**: Ensure you use single quotes around the URL:
   ```python
   # ✅ Correct
   url = "EOPFZARR:'/vsicurl/https://...'"
   
   # ❌ Incorrect  
   url = "EOPFZARR:/vsicurl/https://..."
   ```

2. **Network Access**: The container needs internet access for remote datasets.

3. **Memory**: Large datasets may require increased Docker memory limits.

4. **JupyterHub**: Ensure proper user mapping when deploying in JupyterHub.

## 📞 Support

- **GitHub**: https://github.com/EOPF-Sample-Service/GDAL-ZARR-EOPF
- **Issues**: Report bugs and feature requests on GitHub
- **Docker Hub**: https://hub.docker.com/r/yuvraj1989/eopf-zarr-driver

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.
