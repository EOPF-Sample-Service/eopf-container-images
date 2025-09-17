ARG REGISTRY=harbor.user.eopf.eodc.eu
ARG OWNER=jupyterdask
ARG BASE_IMAGE=$REGISTRY/$OWNER/julia-base
FROM $BASE_IMAGE

LABEL maintainer="EODC for EOPF Project <support@eodc.eu>"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Python dependencies
RUN apt-get update && \
    apt-get install -y \
    s3fs \
    s3cmd && \
    apt-get clean -y

COPY conda-lock.yml /tmp/conda-lock.yml
COPY eopf-jupyterlab/gateway.yml "/home/${NB_USER}/.config/dask/gateway.yaml"

RUN mamba install -y -n base --file /tmp/conda-lock.yml \
    && mamba clean --all --yes \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && rm -rf /opt/conda/pkgs


RUN fix-permissions /etc/jupyter/ \
    && fix-permissions "${CONDA_DIR}"  \
    && fix-permissions "/home/${NB_USER}"
    
USER ${NB_UID}

WORKDIR "${HOME}"
