c = get_config()
import os
# dummy for testing. Don't use this in production!
c.JupyterHub.authenticator_class = 'dummyauthenticator.DummyAuthenticator'
c.DummyAuthenticator.password = "jhubmulty"
#************** Port and IP settings
# we need the hub to listen on all ips when it is in a container
c.JupyterHub.hub_ip = '0.0.0.0'

#*************Spawner settings
# pick a docker image. This should have the same version of jupyterhub
# in it as our Hub.
# launch with docker

c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'

# The admin must pull these before they can be used.
c.DockerSpawner.image_whitelist = {
	'Scipy':'jupyter/scipy-notebook:latest',
	'Data science':'jupyter/datascience-notebook:latest'
}

# tell the user containers to connect to our docker network
c.DockerSpawner.network_name = 'jhubmus'
# delete containers when it stops
c.DockerSpawner.remove = True
#*********** ssl key and cert
c.JupyterHub.ssl_cert = '/srv/jupyterhub/ssl/Yourcert.crt'
c.JupyterHub.ssl_key = '/srv/jupyterhub/ssl/Yourkey.key'
