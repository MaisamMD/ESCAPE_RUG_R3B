ARG BASE_IMAGE=ubuntu:18.04
FROM $BASE_IMAGE

LABEL maintainer="Maisam M.Dadkan <maisam.m.dadkan@gmail.com>"

ARG NB_USER="r3buser"
ARG NB_UID="1000"
ARG NB_GID="100"

# Fix DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
USER root

# Prepare conda envorionment and conda installation
ARG conda_version="4.10.3"
# Miniforge installer patch version
ARG miniforge_patch_number="3"
# Package Manager and Python implementation to use (https://github.com/conda-forge/miniforge)
# - conda only: either Miniforge3 to use Python or Miniforge-pypy3 to use PyPy
# - conda + mamba: either Mambaforge to use Python or Mambaforge-pypy3 to use PyPy
ARG miniforge_python="Mambaforge"
# Miniforge archive to install
ARG miniforge_version="${conda_version}-${miniforge_patch_number}"


# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
#    tini \
    wget \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation \
    run-one && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER="${NB_USER}" \
    NB_UID=${NB_UID} \
    NB_GID=${NB_GID} \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH="${CONDA_DIR}/bin:${PATH}" \
    HOME="/home/${NB_USER}" \
    CONDA_VERSION="${conda_version}" \
    MINIFORGE_VERSION="${miniforge_version}"

# Copy a script that we will use to correct permissions after running certain commands
COPY fix-permissions /usr/local/bin/fix-permissions
RUN chmod a+rx /usr/local/bin/fix-permissions

# Enable prompt color in the skeleton .bashrc before creating the default NB_USER
# hadolint ignore=SC2016
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc && \
   # Add call to conda init script see https://stackoverflow.com/a/58081608/4413446
   echo 'eval "$(command conda shell.bash hook 2> /dev/null)"' >> /etc/skel/.bashrc

# Create NB_USER with name jovyan user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers && \
    useradd -l -m -s /bin/bash -N -u "${NB_UID}" "${NB_USER}" && \
    mkdir -p "${CONDA_DIR}" && \
    chown "${NB_USER}:${NB_GID}" "${CONDA_DIR}" && \
    chmod g+w /etc/passwd && \
    fix-permissions "${HOME}" && \
    fix-permissions "${CONDA_DIR}"

USER ${NB_UID}
ARG PYTHON_VERSION=3.6.9

# Install conda as jovyan and check the sha256 sum provided on the download site
WORKDIR /tmp

# Prerequisites installation: conda, mamba, pip, tini
RUN set -x && \
    # Miniforge installer
    miniforge_arch=$(uname -m) && \
    export miniforge_arch && \
    if [ "$miniforge_arch" == "aarm64" ]; then \
      miniforge_arch="arm64"; \
    fi; \
    miniforge_installer="${miniforge_python}-${miniforge_version}-Linux-${miniforge_arch}.sh" && \
    export miniforge_installer && \
    wget --quiet "https://github.com/conda-forge/miniforge/releases/download/${miniforge_version}/${miniforge_installer}" && \
    /bin/bash "${miniforge_installer}" -f -b -p "${CONDA_DIR}" && \
    rm "${miniforge_installer}" && \
    # Conda configuration see https://conda.io/projects/conda/en/latest/configuration.html
    echo "conda ${CONDA_VERSION}" >> "${CONDA_DIR}/conda-meta/pinned" && \
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true && \
    if [[ "${PYTHON_VERSION}" != "default" ]]; then conda install --yes python="${PYTHON_VERSION}"; fi && \
    conda list python | grep '^python ' | tr -s ' ' | cut -d ' ' -f 1,2 >> "${CONDA_DIR}/conda-meta/pinned" && \
    conda install --quiet --yes \
    "conda=${CONDA_VERSION}" \
    'pip' && \
    conda update --all --quiet --yes && \
    conda clean --all -f -y && \
    rm -rf "${HOME}/.cache/yarn" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "${HOME}"

# Install Tini
RUN conda install --quiet --yes 'tini=0.18.0' && \
 conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_DIR/conda-meta/pinned && \
 conda clean --all -f -y && \
 fix-permissions "${CONDA_DIR}" && \
 fix-permissions "${HOME}"

#Install FairSoft
USER root
COPY fairsoft-prerequisite /tmp/fairsoft-prerequisite
RUN	apt-get update -qq \
 && apt-get install -y $(cat /tmp/fairsoft-prerequisite) \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Using a newer CMake
WORKDIR /opt
RUN wget https://github.com/Kitware/CMake/releases/download/v3.16.4/cmake-3.16.4-Linux-x86_64.sh -O cmake.sh && chmod +x cmake.sh && \
    mkdir /opt/cmake-3.16.4 && ./cmake.sh --skip-license --prefix=/opt/cmake-3.16.4 && \
    rm cmake.sh
ENV PATH="/opt/cmake-3.16.4/bin:${PATH}"

#copy modified source code of fairsoft and install it
WORKDIR	/tmp/fairsoft-build
COPY	./fairsoft.conf ./fairsoft.conf
COPY	./FairSoft-jun19p3 ./FairSoft
RUN cd FairSoft &&  ./configure.sh ../fairsoft.conf && ./make_clean.sh all && cd /tmp && rm -rf /tmp/fair* \
 && apt-get clean && rm -rf /var/lib/apt/lists/* \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "${HOME}"

ENV SIMPATH="/opt/fairsoft_jun19p3" \
    PATH="${SIMPATH}/bin:${PATH}" \
	LD_LIBRARY_PATH="${SIMPATH}/lib:${SIMPATH}/lib/root:${LD_LIBRARY_PATH}" \
	PYTHONPATH="${SIMPATH}/lib/root:${PYTHONPATH}"

USER ${NB_UID}

# Install Jupyter Notebook, Lab, and Hub
# Generate a notebook server config
# Cleanup temporary files
# Correct permissions
# Do all this in a single RUN command to avoid duplicating all of the
# files across image layers when the permissions change
COPY packages /tmp/packages
RUN conda install --quiet --yes --file /tmp/packages \
 && conda clean --all -f -y \
 && npm cache clean --force \
 && jupyter notebook --generate-config \
 && jupyter lab clean \
 && rm -rf "${HOME}/.cache/yarn" \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "${HOME}"

EXPOSE 8888

# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh"]

# Copy local files as late as possible to avoid cache busting
COPY start.sh start-notebook.sh start-singleuser.sh /usr/local/bin/
# Currently need to have both jupyter_notebook_config and jupyter_server_config to support classic and lab
COPY jupyter_notebook_config.py /etc/jupyter/
# Fix permissions on /etc/jupyter as root
USER root
# Prepare upgrade to JupyterLab V3.0 #1205
RUN sed -re "s/c.NotebookApp/c.ServerApp/g" \
    /etc/jupyter/jupyter_notebook_config.py > /etc/jupyter/jupyter_server_config.py \
 && fix-permissions /etc/jupyter/ \
 && echo 'source /opt/fairsoft_jun19p3/bin/thisroot.sh'>> /etc/profile \
 && echo 'echo "The ROOT-CERN configs have been loaded"'>> /etc/profile \
 && jupyter kernelspec install /opt/fairsoft_jun19p3/share/root/etc/notebook/kernels/root \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "${HOME}"

#Switch back to the user
USER ${NB_UID}
#Set the working directory
WORKDIR "${HOME}"
