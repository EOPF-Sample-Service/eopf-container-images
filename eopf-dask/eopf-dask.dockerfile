ARG BASE_CONTAINER=ghcr.io/dask/dask:2025.5.0-py3.11
FROM $BASE_CONTAINER


COPY conda-lock.yml /tmp/conda-lock.yml


RUN mamba install -y -n base --file /tmp/conda-lock.yml \
    && mamba clean -tipy \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs \
    && rm -rf /tmp
    
