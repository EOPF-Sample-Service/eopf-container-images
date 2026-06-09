ARG REGISTRY=quay.io
ARG OWNER=jupyter
ARG BASE_IMAGE=$REGISTRY/$OWNER/minimal-notebook
FROM $BASE_IMAGE

LABEL maintainer="EODC for EOPF Project <support@eodc.eu>"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Julia dependencies
# install Julia packages in /opt/julia instead of ${HOME}
ENV JULIA_DEPOT_PATH=/opt/julia \
    JULIA_PKGDIR=/opt/julia

# Setup Julia
RUN /opt/setup-scripts/setup_julia.py \
    && rm -rf "/home/${NB_USER}/.cache/" \
    && fix-permissions /etc/jupyter/ \
    && fix-permissions "${CONDA_DIR}"  \
    && fix-permissions "/home/${NB_USER}" 
    # Setup IJulia kernel & other packages
    #&& /opt/setup-scripts/setup-julia-packages.bash

COPY eopf-jupyterlab/Manifest.toml /opt/julia/environments/v1.12/
COPY eopf-jupyterlab/Project.toml /opt/julia/environments/v1.12/

RUN fix-permissions "${JULIA_DEPOT_PATH}" \
    && ls -la "${JULIA_DEPOT_PATH}" \ 
    && julia -e "using Pkg; Pkg.instantiate(); Pkg.precompile()" \
    && fix-permissions "${JULIA_DEPOT_PATH}"