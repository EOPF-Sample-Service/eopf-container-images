# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG REGISTRY=quay.io
ARG OWNER=jupyter
ARG BASE_IMAGE=$REGISTRY/$OWNER/minimal-notebook
FROM $BASE_IMAGE

LABEL maintainer="EOPF Project <support@eodc.eu>"

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
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs

# Julia dependencies
# install Julia packages in /opt/julia instead of ${HOME}
ENV JULIA_DEPOT_PATH=/opt/julia \
    JULIA_PKGDIR=/opt/julia

# Setup Julia
RUN /opt/setup-scripts/setup_julia.py

# macOS Rosetta virtualization creates junk directory which gets owned by root further up.
# It'll get re-created, but as USER runner after the next directive so hopefully should not cause permission issues.
#
# More info: https://github.com/jupyter/docker-stacks/issues/2296
# hadolint ignore=DL3059
RUN rm -rf "/home/${NB_USER}/.cache/"

RUN fix-permissions /etc/jupyter/ \
    && fix-permissions "${CONDA_DIR}"  \
    && fix-permissions "/home/${NB_USER}"




# Setup IJulia kernel & other packages
RUN /opt/setup-scripts/setup-julia-packages.bash

USER ${NB_UID}

WORKDIR "${HOME}"