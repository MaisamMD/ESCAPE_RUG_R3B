c = get_config()
import os
# dummy for testing. Don't use this in production!
c.JupyterHub.authenticator_class = 'dummyauthenticator.DummyAuthenticator'
#************** Port and IP settings
# we need the hub to listen on all ips when it is in a container
c.JupyterHub.hub_ip = '0.0.0.0'
#c.JupyterHub.ip = ''
# The port for this process
#c.JupyterHub.hub_port = 8000
#c.JupyterHub.port = 8000
# the hostname/ip that should be used to connect to the hub
# this is usually the hub container's name
#c.JupyterHub.hub_connect_ip = 'jhub_ssl'
#*************Spawner settings
# pick a docker image. This should have the same version of jupyterhub
# in it as our Hub.
# launch with docker
c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'
c.DockerSpawner.image = 'jupyter/scipy-notebook:latest'
c.DockerSpawner.volumes = {'/An/Absolute/Path/To/A Directory/In/Your host':'/home/jovyan/work'}
# tell the user containers to connect to our docker network
c.DockerSpawner.network_name = 'jhubssl'
# delete containers when the stop
c.DockerSpawner.remove = True
#*********** ssl key and cert
c.JupyterHub.ssl_cert = '/srv/jupyterhub/ssl/myssl.crt'
c.JupyterHub.ssl_key = '/srv/jupyterhub/ssl/myssl.key'
