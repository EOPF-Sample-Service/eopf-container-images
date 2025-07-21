# EOPF-Zarr GDAL Driver Container
# 
# This container provides:
# - Ubuntu 25.04 with GDAL 3.10.x
# - Complete EOPF Python environment 
# - Custom EOPF-Zarr GDAL driver for reading Zarr-based EO data
# - JupyterLab environment compatible with JupyterHub deployment
#
# Built for: https://jupyterhub.user.eopf.eodc.eu
#
# Usage:
#   docker build -f eopf-zarr-driver.dockerfile -t eopf-zarr-driver:latest .
#   docker run -p 8888:8888 eopf-zarr-driver:latest

FROM ubuntu:25.04

# Metadata
LABEL maintainer="EOPF Team"
LABEL description="EOPF-Zarr GDAL Driver with Complete EOPF Environment"
LABEL version="1.0.0"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV JUPYTER_ENABLE_LAB=yes
ENV GDAL_DRIVER_PATH="/opt/eopf-zarr/drivers"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    # Build tools
    build-essential \
    cmake \
    git \
    pkg-config \
    # System libraries
    gdal-bin \
    libgdal-dev \
    gdal-data \
    # Python and pip
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    # Additional utilities
    curl \
    wget \
    unzip \
    # Cleanup
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Verify GDAL installation
RUN gdalinfo --version && \
    python3 -c "from osgeo import gdal; print(f'GDAL Python bindings: {gdal.__version__}')"

# Install Python packages for EOPF environment
# Using --break-system-packages as required by Ubuntu 25.04 PEP 668
RUN python3 -m pip install --break-system-packages --no-cache-dir \
    # Core scientific stack
    numpy \
    scipy \
    pandas \
    matplotlib \
    # Geospatial stack
    xarray \
    zarr"<3" \
    dask \
    geopandas \
    rasterio \
    fiona \
    shapely \
    pyproj \
    # Data formats
    netcdf4 \
    h5py \
    # Visualization
    cartopy \
    # Jupyter ecosystem
    jupyter \
    jupyterlab \
    ipywidgets \
    ipykernel \
    # JupyterHub compatibility
    jupyterhub \
    notebook

# Create directory structure
RUN mkdir -p /opt/eopf-zarr/drivers /opt/eopf-zarr/build

# Clone and build EOPF-Zarr driver from GitHub
WORKDIR /opt/eopf-zarr
RUN git clone https://github.com/EOPF-Sample-Service/GDAL-ZARR-EOPF.git source \
    && cd source \
    && git checkout main

# Build EOPF-Zarr GDAL driver
WORKDIR /opt/eopf-zarr/build
RUN cmake ../source \
    && make -j$(nproc) \
    && echo "Build completed. Files in build directory:" \
    && ls -la \
    && echo "Looking for gdal_EOPFZarr.so..." \
    && find . -name "*gdal*" -o -name "*EOPF*" \
    && echo "Checking drivers directory exists..." \
    && ls -la /opt/eopf-zarr/ \
    && cp gdal_EOPFZarr.so /opt/eopf-zarr/drivers/gdal_EOPFZarr.so \
    && echo "Driver copied successfully to /opt/eopf-zarr/drivers/"

# Verify driver installation
RUN gdalinfo --formats | grep -i eopf || echo "Driver will be loaded at runtime"

# Create non-root user for Jupyter
RUN useradd -m -s /bin/bash jupyter && \
    echo "jupyter:jupyter" | chpasswd

# Create working directory
RUN mkdir -p /home/jupyter/work && \
    chown -R jupyter:jupyter /home/jupyter

# Copy entrypoint script and test files
COPY docker-entrypoint.sh /usr/local/bin/
COPY test-environment.py /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/test-environment.py

# Create sample workspace
RUN mkdir -p /home/jupyter/work/examples \
    && echo "# EOPF-Zarr Driver Test Environment" > /home/jupyter/work/README.md \
    && echo "This environment includes the EOPF-Zarr GDAL driver." >> /home/jupyter/work/README.md \
    && echo "Use the following to test:" >> /home/jupyter/work/README.md \
    && echo "python /usr/local/bin/test-environment.py" >> /home/jupyter/work/README.md \
    && cp /usr/local/bin/test-environment.py /home/jupyter/work/ \
    && chown -R jupyter:jupyter /home/jupyter/work

# Switch to non-root user
USER jupyter
WORKDIR /home/jupyter/work

# Expose Jupyter port
EXPOSE 8888

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]
