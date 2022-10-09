# R3BRoot Docker Stack for ESCAPE

## introduction
The R3B experiment is one the upcoming experiments at the [FAIR-GSI](https://fair-center.eu/) facility at Darmstadt Germany. The R3B setup is a multi-purpose experimental setup used to study nuclear structure properties of short-lived isotopes through inverse kinematic reactions. The heart of the R3B setup consists of a fixed target, where the secondary beam from the Super-FRS is shot on. The general goal of the R3B experiment is to then provide a kinematically complete reconstruction of all particles participating in the reaction, so that the nuclear structure of the beam isotope can be studied. Each type of outgoing particles is detected by a specific type of detector. The neutrons produced at the target, which are generally also very forward-boosted, are detected by Neu-LAND (Neu Large-Area Neutron Detector). The problem of finding the shower head among all the scintillator signals in Neu-LAND is challenging. Especially in the situation where multiple neutrons have to be detected in coincidence, solutions are far from trivial because of two reasons:

1. it is not (always) known a prior how many neutrons were detected.
2. showers from distinct neutrons tend to overlap quite often.

Two analysis approaches have been developed to analyze the data of the NueLAND:
* Technical Design Report (TDR)
* Deep Neural Network (DNN)

This software package like many others scientific packaged is complicated to install and configure and has only command line interface by default. We aimed to make the R3BRoot framework as a service by providing it as a form of docker image. The R3BRoot use the base libraries of the standard FAIR software framework, FairSoft and FairRoot. For each of these packages we provided a separate Dockerfile. Therefore, each Dockerfile build its own Docker image. We provided a scripts that automate this process and build all the Docker images starting from FairSoft. The running Docker image (called Docker container) does not have GUI by default. To make it more user friendly the whole R3BRoot software stack is interfaced with Jupyter Notebook which makes users able to write analysis codes in both C++ and Python3 using the web browser and see the graphical outputs between the code blocks. For more details about each part, please read the corresponding README file.

## Installation
To use this software stack, one needs to have the Docker engine installed on the machine. For installing Docker, see [Docker-Install](https://docs.docker.com/engine/install/) page.
To build all the R3BRoot Docker stack image, you can run build-docker.sh script. This script check if the Dockerfiles are exist and start to build each image (FairSoft, FairRoot, R3BRoot) separately one after another. This process might take a few hours. If you would like to build each Docker image manually, please check the corresponding README.md file.
