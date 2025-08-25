# EOPF-Zarr GDAL Driver - Simplified Docker Image
# Based on Jupyter minimal-notebook for JupyterHub compatibility
ARG REGISTRY=quay.io
ARG OWNER=jupyter
ARG BASE_IMAGE=$REGISTRY/$OWNER/minimal-notebook
FROM $BASE_IMAGE

LABEL maintainer="EOPF Sample Service"
LABEL description="EOPF-Zarr GDAL Driver with Jupyter base, GDAL, and EOPF Python environment"
LABEL version="3.0.0"

USER root

# Install GDAL and system dependencies
RUN apt-get update && apt-get install -y \
    gdal-bin \
    libgdal-dev \
    python3-gdal \
    git \
    cmake \
    build-essential \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Set GDAL driver path
ENV GDAL_DRIVER_PATH=/opt/eopf-zarr/drivers

# Create driver directory and build EOPF-Zarr driver
RUN mkdir -p /opt/eopf-zarr/drivers && \
    git clone --depth 1 https://github.com/EOPF-Sample-Service/GDAL-ZARR-EOPF.git /tmp/eopf-zarr && \
    cd /tmp/eopf-zarr && \
    mkdir build && cd build && \
    cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DGDAL_ROOT=/usr && \
    make -j$(nproc) && \
    cp gdal_EOPFZarr.so /opt/eopf-zarr/drivers/ && \
    rm -rf /tmp/eopf-zarr

# Set driver path in environment
RUN echo 'export GDAL_DRIVER_PATH=/opt/eopf-zarr/drivers' >> /etc/environment

USER $NB_UID

# Install Python packages
RUN pip install --no-cache-dir \
    GDAL==$(gdal-config --version) \
    --no-binary=rasterio rasterio \
    xarray \
    zarr \
    dask \
    geopandas \
    fiona \
    shapely \
    matplotlib \
    netcdf4 \
    h5py
