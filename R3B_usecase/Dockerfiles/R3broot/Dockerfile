ARG BASE_IMAGE=fairroot:latest
FROM $BASE_IMAGE

LABEL maintainer="Maisam M.Dadkan <maisam.m.dadkan@gmail.com>"

USER root
WORKDIR "${HOME}"
RUN	git clone https://github.com/R3BRootGroup/R3BRoot.git && cd R3BRoot \
 && git checkout dev \
 &&	git clone https://github.com/R3BRootGroup/macros.git \
 &&	cd macros \
 &&	git checkout dev
#Add DNN code
WORKDIR "${HOME}/R3BRoot"
COPY	./DNN ./DNN
COPY  ./CMakeLists.txt ./CMakeLists.txt
RUN	cd /opt && mkdir -vp r3broot_build \
 && cd r3broot_build \
 && export FAIRROOTPATH=/opt/fairroot_v18.2.1 \
 && cmake ${HOME}/R3BRoot && make \
 && echo 'source /opt/r3broot_build/config.sh'>> /etc/profile

#Switch back to the user
USER ${NB_UID}
RUN conda install --quiet --yes \
	'ipywidgets=7.6.*' \
	'wheel'\
	'tensorflow=1.9.0'\
	'keras=2.1.6'\
	'widgetsnbextension=3.5.*'\
 && conda clean --all -f -y \
 && npm cache clean --force \
 && rm -rf "${HOME}/.cache/yarn" \
 && fix-permissions "${CONDA_DIR}"

USER root
RUN fix-permissions "${HOME}"
USER ${NB_UID}
#Set the working directory
WORKDIR "${HOME}"
