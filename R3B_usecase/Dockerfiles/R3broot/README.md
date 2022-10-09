# R3BRoot

The present docker file will install [R3BRoot](https://www.r3broot.gsi.de/) on top
of the prebuild FairSoft+FairRoot docker image. To do that, it will use a
modified version of the R3BRoot source code that is in the /DNN directory.
The main modified parts are blongs to the simulation and analysis codes which need
a graphical interface by default. Therefore, all the simualtion and analysis codes
have been forced to run in the batch mode.
The main usage of this docker image is to run the R3B Monte Carlo simulation
and Deep Neural Network (DNN) data analysis code for the NeuLAND detector of the
[R3B experiment](https://www.r3b-nustar.de/).
To do that, all the essential python deep learning libraries will be installed in this
image such as TensorFlow, Keras, Numpy, and...

To build this image you can run the following command:

```bash
docker build --no-cache -t r3broot .
```

After building the image, you can run it using the command

```bash
docker run -it --rm --name my-r3broot -p 8888:8888 r3broot
```
and navigate to the http://localhost:8888 to access the Jupyter Lab environment using the
generated token by the jupyternotebook.