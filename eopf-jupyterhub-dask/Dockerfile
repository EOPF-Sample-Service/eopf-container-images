# Docker Image for EOPF compatible with JupyterHub and Dask Cluster
# This image performs SAFE to Zarr conversion using the Dask Cluster
# Base image: Official EOPF image from EOPF CPM

FROM registry.eopf.copernicus.eu/cpm/eopf-cpm:2-6-3

LABEL maintainer="EOPF Sample Service"
LABEL description="EOPF Docker image compatible with JupyterHub and Dask Cluster for SAFE to Zarr conversion"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Install system dependencies if needed
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    curl \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install required Python packages using pip
# These packages are required for JupyterHub compatibility and Dask operations
# Note: dask, dask-gateway, and distributed are already in the base image installed for dask user
# Install system-wide so they're available for all users
RUN pip install --no-cache-dir \
    jupyterhub \
    jupyterlab \
    jupyterlab-myst \
    jupyterlab-git \
    nbgitpuller \
    dask-labextension

# Add dask user's local packages to Python path so EOPF packages are accessible
ENV PYTHONPATH="/home/dask/.local/lib/python3.11/site-packages:${PYTHONPATH}"

# Expose JupyterLab port
EXPOSE 8888

# Default command (will be overridden by JupyterHub)
CMD ["jupyterhub-singleuser"]
