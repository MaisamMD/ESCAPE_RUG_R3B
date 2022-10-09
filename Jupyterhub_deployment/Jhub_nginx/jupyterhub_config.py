c = get_config()
import os
# dummy for testing. Don't use this in production!
c.JupyterHub.authenticator_class = 'dummyauthenticator.DummyAuthenticator'
#************** Port and IP settings
# we need the hub to listen on all ips when it is in a container
c.JupyterHub.hub_ip = '0.0.0.0'
c.JupyterHub.bind_url = 'http://jhub:8000'
#*************Spawner settings
# pick a docker image. This should have the same version of jupyterhub
# in it as our hub service.
# launch with docker
c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'
c.DockerSpawner.image = 'jupyter/scipy-notebook:latest'

#Add a directory from your host to be mapped to the spawned container.
#c.DockerSpawner.volumes = {'/An/Absolute/Path/To/A Directory/In/Your host':'/home/jovyan/work'}

# tell the user containers to connect to the defined docker network in the docker-compose file
c.DockerSpawner.network_name = 'jhubnginx'
# delete containers when it stops
c.DockerSpawner.remove = True
