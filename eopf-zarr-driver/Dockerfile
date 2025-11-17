# EOPF-Zarr Driver - Production Ready with Fixed ReadAsArray
# Fixes: ReadAsArray "_gdal_array import error" and EOPF plugin compatibility  
# Solution: GDAL 3.10.3 (conda) + proper plugin placement
# Base: Uses dask-notebook which already includes xarray, zarr, dask, matplotlib
FROM ghcr.io/dask/dask-notebook:latest

LABEL maintainer="EOPF Sample Service"
LABEL description="EOPF-Zarr GDAL Driver with working ReadAsArray and EOPF plugin functionality"
LABEL version="4.0.0"

USER root

# Install only build dependencies needed for EOPF driver compilation
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

USER $NB_UID

# CRITICAL: Upgrade to GDAL 3.10.x via conda-forge to fix ReadAsArray
# This provides proper gdal_array integration for ReadAsArray functionality
RUN mamba install -y -c conda-forge \
    'gdal>=3.10,<3.11' \
    rasterio \
    xarray \
    zarr \
    matplotlib \
    nbgitpuller \
    mystmd \
    jupyterlab-myst \
    jupyterhub-singleuser \
    && mamba clean --all -f -y

# Verify GDAL version is in the working range (matches Windows success criteria)
RUN python -c "from osgeo import gdal; v=gdal.VersionInfo(); print(f'GDAL {v}'); assert int(v) >= 3100000 and int(v) < 3110000"

USER root

# Build EOPF-Zarr driver against conda GDAL 3.10.x
RUN git clone --depth 1 https://github.com/EOPF-Sample-Service/GDAL-ZARR-EOPF.git /tmp/eopf-zarr && \
    cd /tmp/eopf-zarr && \
    mkdir build && cd build && \
    export PATH="/opt/conda/bin:$PATH" && \
    export PKG_CONFIG_PATH="/opt/conda/lib/pkgconfig:$PKG_CONFIG_PATH" && \
    cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_PREFIX_PATH="/opt/conda" \
        -DGDAL_INCLUDE_DIR="/opt/conda/include" \
        -DGDAL_LIBRARY="/opt/conda/lib/libgdal.so" \
        -DCMAKE_INSTALL_RPATH="/opt/conda/lib" \
        -DCMAKE_BUILD_RPATH="/opt/conda/lib" && \
    make -j$(nproc) && \
    echo "Built EOPF driver with GDAL $(gdal-config --version)" && \
    # SOLUTION: Copy to actual GDAL plugin directory (not custom path)
    cp gdal_EOPFZarr.so /opt/conda/lib/gdalplugins/ && \
    rm -rf /tmp/eopf-zarr

# Set library path for proper GDAL linking
ENV LD_LIBRARY_PATH="/opt/conda/lib:/opt/conda/lib64"

USER $NB_UID
WORKDIR /home/jovyan

# Verify solution works on build
RUN python -c "from osgeo import gdal, gdal_array; gdal.AllRegister(); assert gdal.GetDriverByName('EOPFZarr'), 'EOPF driver not loaded'; print('✅ GDAL', gdal.VersionInfo(), '- ReadAsArray and EOPF plugin ready!')"
