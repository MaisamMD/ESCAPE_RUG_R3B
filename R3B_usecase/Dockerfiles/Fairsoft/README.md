# FairSoft + Jupyter Notebook 

FairSoft is the base of all the data analysis and the simulation softwares of the experiments which are running at [GSI-FAIR](https://www.gsi.de/en/start/news.htm).
FairSoft consists of different software packages such as Root, Geant4, Geant3, and etc.. For more details about what are included in the FairSoft, see FairSoft-jun19p3/README.md file.
This Docker file will install the FairSoft and the rquired packages to intrface C++-Root and PyRoot environment with Jupyter Notebook in a Docker image on the ubuntu 18.04 LTS. In order to make PyRoot compatible with Jupytet Notebook, we tweaked the original installation files of FairSoft to build all Python madules against the Conda version that Jupyter is based on. 
Besides the Dockerfile that is self-explanatory, there are a few input files which are described below:
* fix-permissions: set permissions on a directory after any installation, if a directory needs to be (human) user-writable, run this script on it. It will make everything in the directory owned by the group ${NB_GID} and writable by that group.

* start.sh,start-notebook.sh, start-singleuser.sh: These files used to define different type of starting of the jupyter-notebook. start-notebook.sh also includes a part that configure the fairsoft madules when the container starts to run. Here, we use only this file to setup the environment of the running container.

* packages: The list of essential packages together with jupyter notebook and hub. This list is called when using conda install command. If you would like to install different version of the aforementioned packages, you can modify this file(taking into account the possible incompatibility issues).

* jupyter-notebook-config.py: The standard base notebook configuration file.

* fairsoft-prerequisite: a list of packeges that need to be installed for the fairsoft. This list will be called before installing the fairsoft in the Dockerfile.

* fairsoft.conf: The standard options for the fairsoft installation. This file will be called in the Dockerfile.

Since we have modified a few parts of the fairsoft configuration file, the modified version of the fairsoft is in the FairSoft-jun19p3 directory.
## Build the Docker image

To build the image you need to excecute the Dockerfile and tag it:

```bash
docker build --no-cache -t fairsoft-conda .
```
It might take an hour (or more) to install the packges and build the image.

## Run the Docker container
After succefully building the image, you can run a container using the built image:

```bash
docker run -it -p 8888:8888 --rm fairsoft-conda --name my-fairsoft
```
To have a shell access in the inside the running container, simply run the following commands:

```bash
docker run -it -d -p 8888:8888 --rm fairsoft-conda --name my-fairsoft
```
and then 
```bash
docker exec -it my-fairsoft /bin/bash
```

Since the containers does not have graphical user interface by default, you have to run any software in the batch mode. For example, for running Root-Cern you can use:

```bash
root -b -l
```
