# EOPF-Zarr Driver Demo

Welcome to the EOPF-Zarr driver demonstration!

## Getting Started

This notebook demonstrates how to use the EOPF-Zarr GDAL driver to access remote Zarr datasets.

### Example Usage

```python
import rasterio
from osgeo import gdal

# Example remote Zarr URL
url = "EOPFZARR:'/vsicurl/https://storage.sbg.cloud.ovh.net/v1/AUTH_8471d76cdd494d98a078f28b195dace4/sentinel-1-public/demo_product/grd/S01SIWGRH_20240201T164915_0025_A146_S000_5464A_VH.zarr'"

# Open with rasterio
with rasterio.open(url) as src:
    print(f"Dataset shape: {src.shape}")
    print(f"Dataset CRS: {src.crs}")
    print(f"Dataset bounds: {src.bounds}")
```

### Testing EOPF-Zarr Functionality

Run the built-in test suite:

```python
exec(open('/usr/local/bin/test-environment.py').read())
```
