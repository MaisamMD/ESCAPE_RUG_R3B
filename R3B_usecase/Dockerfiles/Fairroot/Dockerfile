ARG BASE_IMAGE=fairsoft-conda:latest
FROM $BASE_IMAGE

LABEL maintainer="Maisam M.Dadkan <maisam.m.dadkan@gmail.com>"

USER root
# #
# # FairRoot
# #
WORKDIR /tmp/fairroot-build
RUN  git clone https://github.com/FairRootGroup/FairRoot.git -b v18.2.1 FairRoot \
 &&  mkdir -vp FairRoot_build \
 &&  fix-permissions "${CONDA_DIR}" \
 &&  fix-permissions "${HOME}" \
 &&  source /etc/profile \
 &&  echo $SIMPATH \
 &&  cmake -S FairRoot -B FairRoot_build -DCMAKE_INSTALL_PREFIX=/opt/fairroot_v18.2.1 \
 &&  make -C FairRoot_build -j2 install \
 &&  echo 'source /opt/fairroot_v18.2.1/bin/FairRootConfig.sh'>> /etc/profile \
 &&  echo 'echo "The FAIRROOT configs have been loaded"'>> /etc/profile \
 &&  cd /tmp && rm -rf /tmp/fair*

#ENV FAIRROOTPATH=/opt/fairroot_v18.2.1
#Switch back to the user
USER ${NB_UID}
#Set the working directory
WORKDIR "${HOME}"
