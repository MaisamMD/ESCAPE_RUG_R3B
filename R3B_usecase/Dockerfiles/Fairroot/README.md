# Fairroot

The FairRoot framework is an object oriented simulation, reconstruction and data analysis framework. It includes core services for detector simulation and offline analysis of particle physics data. FairRoot is the standard simulation, reconstruction and data analysis framework for the [FAIR](https://fair-center.eu/) experiments at GSI Darmstadt . The framework enable the users to design and/or construct their detectors and /or analysis tasks in a simple way, it also delivers some general functionality like track visualization.
Here, we provide and confugured a Docker image for FairRoot based on the FairSoft
Docker image that is provided in this software stack.

To build the image you need to excecute the Dockerfile and tag it:

```bash
docker build --no-cache -t fairroot .
```
After building the image, you can run it using the command

## Run to use in the jupyternotebook environment

```bash
docker run -it --rm --name my-fairroot -p 8888:8888 fairroot
```

## Run to use in the batch environment

```bash
docker run -it --rm -d --name my-fairroot fairroot
```

and then enter the following command to have access to the command line interface (CLI) of the running container:

```bash
docker exec -it my-fairroot /bin/bash
```


