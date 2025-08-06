ARG BASE_CONTAINER=ghcr.io/dask/dask-notebook:2025.5.0-py3.11
FROM $BASE_CONTAINER

USER root

RUN apt-get update && \
    apt-get install -y \
    s3fs \
    s3cmd && \
    apt-get clean -y

USER ${NB_UID}

COPY conda-lock.yml /tmp/conda-lock.yml

RUN mamba install -y -n base --file /tmp/conda-lock.yml \
    && mamba clean --all --yes \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs \
    && fix-permissions "${CONDA_DIR}"  \
    && fix-permissions "/home/${NB_USER}"

USER root
RUN fix-permissions /etc/jupyter/

RUN rm -rf "/home/${NB_USER}/.cache/"

USER ${NB_UID}

WORKDIR "${HOME}"

RUN rm -rf "/home/${NB_USER}/examples"
