# JupyterHub configurations

In this repository you can find different configurations for running jupyterhub.
I tries to provide simple working configurations for jupyterhub based on docker-spawner.
In each subdirectory you can find the corresponding jupyterhub_config.py with a
dokcer compose file to run the service.
First of all you need to build a jupyterhub docker images that includes all the
libraries which we need for each configuration settings.
If you wish to add more libraries, add them in the requirement.txt
This will build a docker image for jupyterhub with the name jupyterhub:latest.
This image will be used in different configurations provided in this repository.
Then you can navigate to each directory and run the jupyterhub by running the
docker compose file there.  For more information, see the corresponding README
file of each subdirectory.

## Jhub_base

 This is a simple configuration for jupyterhub with the following features:

 - Using Docker Spawner to run a standard Jupyter Notebook (Lab)
 - Dummy authentication
 - Map a folder in the host to the notebook container as a persistent data storage

## Jhub_ssl

  This is a configuration for jupyterhub with the following features
  (in addition to the Jhub_base):

 - Enabled https using ssl certificate and key for the jupyterhub

## Jhub_multyspawner
This is jupyterhub service that provide a spwaner list of the notebook images:

 - Enabled the Multyspawning option to choose from a list of images.
 - Used dummy authentication with a given password

## Jhub_nginx
A jupyterhub service which is running behind nginx as a reveres proxy with enabled https.

 - Running nginx as a reverse proxy in front of jupyterhub
 - Https enabled for nginx using ssl

## Jhub_r3b
A jupyterhub service with a login page designed for the R3B experiment. The other features are the same as the Jhub_base version.

## Jhub_IAM
This Jupyterhub is configured to be able to use ESCAPE-IAM as the Auth/Z service. The base configuretion is the same as Jhub_ssl except the authentication part. For more details, see the README file in the directory.

