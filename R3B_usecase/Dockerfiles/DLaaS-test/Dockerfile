FROM r3broot:921_1
LABEL maintainer="Muhammad Aditya Hilmy <mhilmy@hey.com>"

USER $NB_UID


RUN pip install rucio-jupyterlab>=0.9.7 swanoauthrenew==1.0.1 PyJWT\
    && jupyter serverextension enable --py rucio_jupyterlab --sys-prefix \
    && jupyter serverextension enable --py swanoauthrenew --sys-prefix \
    && pip install reana-client

USER root

RUN apt-get update -y \
    && apt-get install -y voms-clients-java software-properties-common \
    && apt-get clean -y \
#    && rm /opt/conda/bin/voms-proxy-init \
    && ln -s /usr/bin/voms-proxy-init /opt/conda/bin/voms-proxy-init

# ESCAPE grid-security and VOMS setup
RUN wget -q -O - https://dist.eugridpma.info/distribution/igtf/current/GPG-KEY-EUGridPMA-RPM-3 | apt-key add -

RUN apt-get update \
    && add-apt-repository 'deb http://repository.egi.eu/sw/production/cas/1/current egi-igtf core' \
    && apt-get -y install ca-certificates ca-policy-egi-core

RUN mkdir -p /etc/vomses \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.vomses -O /etc/vomses/voms-escape.cloud.cnaf.infn.it.vomses \
    && mkdir -p /etc/grid-security/vomsdir/escape \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.lsc -O /etc/grid-security/vomsdir/escape/voms-escape.cloud.cnaf.infn.it.lsc

# Setup merged CERN CA file
RUN mkdir /certs \
    && touch /certs/rucio_ca.pem \
    && cat /etc/grid-security/certificates/CERN-Root-2.pem >> /certs/rucio_ca.pem \
    && cat /etc/grid-security/certificates/CERN-GridCA.pem >> /certs/rucio_ca.pem

# Setup extension Rucio instance config
ADD bin/configure.py /opt/escape-datalake/configure.py
ADD bin/configure.sh /usr/local/bin/configure.sh
RUN fix-permissions /opt/escape-datalake \
#    && echo 'python /opt/escape-datalake/configure.py'>> /etc/profile \
    && fix-permissions /usr/local/bin/configure.sh \
    && sed -i -e 's/\r$/\n/' /usr/local/bin/configure.sh

# Default environment variables for ESCAPE Data Lake
ENV RUCIO_MODE=download
ENV RUCIO_WILDCARD_ENABLED=1
ENV RUCIO_BASE_URL=https://escape-rucio.cern.ch
ENV RUCIO_AUTH_URL=https://escape-rucio-auth.cern.ch
ENV RUCIO_WEBUI_URL=https://escape-rucio-webui.cern.ch
ENV RUCIO_DISPLAY_NAME="ESCAPE Data Lake"
ENV RUCIO_NAME=escape
ENV RUCIO_VOMS_ENABLED=1
ENV RUCIO_VOMS_VOMSES_PATH=/etc/vomses
ENV RUCIO_VOMS_CERTDIR_PATH=/etc/grid-security/certificates
ENV RUCIO_VOMS_VOMSDIR_PATH=/etc/grid-security/vomsdir
ENV RUCIO_CA_CERT=/certs/rucio_ca.pem
ENV RUCIO_DEFAULT_INSTANCE="escape"

RUN mkdir -p /opt/rucio \
    && chown -R $NB_UID /opt/rucio \
    && /usr/local/bin/configure.sh \
    && chown -R $NB_UID /etc/jupyter/jupyter_notebook_config.json \
    && chown -R $NB_UID /etc/jupyter/jupyter_notebook_config.py

# Auto load kernel extension when loading IPython
ENV IPYTHONDIR=/etc/ipython
ADD ipython_kernel_config.json /etc/ipython/profile_default/ipython_kernel_config.json
RUN chown -R $NB_UID /etc/ipython
ENV JUPYTER_ENABLE_LAB=yes

WORKDIR $HOME
USER $NB_UID

CMD ["configure.sh", "start-notebook.sh"]
