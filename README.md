# eopf-container-images
Container Images used in the EOPF Sentinel Zarr Samples

## Available Images

### eopf-jupyterhub-dask
Docker image based on the official EOPF CPM image, compatible with JupyterHub and configured for Dask cluster operations. Designed for SAFE to Zarr conversion workflows.

**Location**: `eopf-jupyterhub-dask/`

**Base Image**: `registry.eopf.copernicus.eu/cpm/eopf-cpm:2-6-3`

**Key Features**:
- JupyterHub single-user server support
- JupyterLab with extensions (Git, MyST)
- Dask and Dask Gateway for distributed computing
- Ready for SAFE to Zarr conversion

See [eopf-jupyterhub-dask/README.md](eopf-jupyterhub-dask/README.md) for details.

### eopf-jupyterlab
Custom JupyterLab environment with EOPF dependencies.

**Location**: `eopf-jupyterlab/`

### eopf-dask
Dask cluster configuration for EOPF.

**Location**: `eopf-dask/`

### eopf-zarr-driver
Zarr driver utilities and demonstrations.

**Location**: `eopf-zarr-driver/`
