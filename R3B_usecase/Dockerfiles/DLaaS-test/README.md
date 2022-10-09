# ESCAPE Data Lake-as-a-Service Singleuser Base Image

This image is derived from [jupyter/scipy-notebook](https://hub.docker.com/r/jupyter/scipy-notebook) with some modifications:

1. Python version is downgraded to version 3.8 due to compatibility issues with some libraries, including PyROOT.
2. [rucio-jupyterlab](https://pypi.org/project/rucio-jupyterlab) is installed.
3. [rucio-clients](https://pypi.org/project/rucio-clients) is upgraded to version 1.28.4.
4. ESCAPE `ca-certificates` and VOMSes files are preinstalled.
5. The configuration for the Rucio JupyterLab extension is preset to connect with the ESCAPE Data Lake.
6. [python-gfal2](https://anaconda.org/conda-forge/python-gfal2) and voms-clients-java is installed to enable direct Rucio Download functionality.
7. [swanoauthrenew](https://pypi.org/project/swanoauthrenew/) is installed to enable automatic OIDC token refresh.

## Using the image as a standalone instance

If you want to take advantage of the extension's capability in your own machine, you can do a simple Docker run:

```sh
docker run -p 8888:8888 gitlab-registry.cern.ch/escape-wp2/docker-images/datalake-singleuser:latest
```

You can also override the default environment values specified in [Dockerfile](dockerfile). Take a closer look at [bin/configure.py](bin/configure.py) to see available envs. Refer to [this configuration guide](https://github.com/rucio/jupyterlab-extension/blob/master/CONFIGURATION.md) for details.

## Extending the image

If you want to extend the image and use it as a part of the ESCAPE Data Lake-as-a-Service service, there are some things to remember:

1. Try not to modify the `CMD` directive. But if you really need to do this, make sure that `configure.sh` (located in `/usr/local/bin/configure.sh`) is called, since that script is responsible for setting up the extension and OIDC parameters.
2. If you need to add a file, make sure that the container user has the necessary permission to access the file. You can use envs `$NB_UID`, `$NB_GID`, `$NB_USER`, and `$HOME` to get the user ID, group ID, username, and home directory respectively.
3. Make sure that the user and workdir values are set to their original values:

```
WORKDIR $HOME
USER $NB_UID
```

An example of an image that extends this image is the [datalake-singleuser-root](https://gitlab.cern.ch/escape-wp2/docker-images/-/tree/master/datalake-singleuser-root) image, which comes with PyROOT preinstalled.
