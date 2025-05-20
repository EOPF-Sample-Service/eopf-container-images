ARG BASE_CONTAINER=ghcr.io/dask/dask:2025.5.0-py3.11
FROM $BASE_CONTAINER

RUN mamba install -y \
    dask-gateway \
    xarray \
    netCDF4 \
    bottleneck \
    zarr \
    fsspec \
    gdal \
    xarray-eopf \
    && mamba clean -tipy \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs