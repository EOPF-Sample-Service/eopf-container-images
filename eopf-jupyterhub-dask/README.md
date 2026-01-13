# EOPF JupyterHub Dask Image

## Overview

This Docker image is designed for performing SAFE to Zarr conversion using the Dask Cluster. It is based on the official EOPF image and is compatible with JupyterHub deployments.

## Base Image

- **Base**: `registry.eopf.copernicus.eu/cpm/eopf-cpm:2-6-3`
- Official EOPF image from the EOPF CPM registry

## Features

- **JupyterHub Compatible**: Includes `jupyterhub-singleuser` for seamless integration with JupyterHub
- **JupyterLab**: Full JupyterLab environment with extensions
- **Dask Support**: Configured with Dask and Dask Gateway for distributed computing
- **Git Integration**: Includes JupyterLab Git extension and nbgitpuller
- **MyST Support**: Markdown and MyST support via jupyterlab-myst

## Included Packages

- `jupyterhub-singleuser` - JupyterHub single-user notebook server
- `jupyterlab` - JupyterLab interface
- `jupyterlab-myst` - MyST Markdown support
- `jupyterlab-git` - Git extension for JupyterLab
- `nbgitpuller` - Pull notebooks from Git repositories
- `dask` - Parallel computing library
- `dask-gateway` - Gateway for Dask clusters
- `distributed` - Distributed computing with Dask

## Docker Hub

The image is available on Docker Hub:

```bash
docker pull yuvraj1989/eopf-jupyterhub-dask:latest
# or specific version
docker pull yuvraj1989/eopf-jupyterhub-dask:1.0.0
```

**Docker Hub Repository**: https://hub.docker.com/r/yuvraj1989/eopf-jupyterhub-dask

## Building the Image

```bash
docker build -t eopf-jupyterhub-dask:latest -f eopf-jupyterhub-dask/Dockerfile .
```

## Running the Image

### Standalone Mode

```bash
docker run -p 8888:8888 yuvraj1989/eopf-jupyterhub-dask:latest
```

### With JupyterHub

This image is designed to be used with JupyterHub. Configure your JupyterHub to use this image:

```python
c.DockerSpawner.image = 'yuvraj1989/eopf-jupyterhub-dask:latest'
```

## Related Issues and PRs

- Issue: [#43 - Create Docker image with eopf compatible with JupyterHub and Dask Cluster](https://github.com/EOPF-Sample-Service/eopf-container-images/issues/43)
- Related Issue: https://github.com/EOPF-Sample-Service/eopf-sample-notebooks/issues/185
- Related PR: https://github.com/EOPF-Sample-Service/eopf-sample-notebooks/pull/186

## Usage for SAFE to Zarr Conversion

This image includes all necessary dependencies for performing SAFE to Zarr conversion with Dask. Users can run the conversion notebooks in a JupyterHub environment with Dask cluster support.

## Maintenance

Maintained by: EOPF Sample Service Team
