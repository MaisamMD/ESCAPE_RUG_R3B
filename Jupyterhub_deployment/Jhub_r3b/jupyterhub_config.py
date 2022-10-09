c = get_config()
import os
###############Aouthentication and Aoutorization section############3
# dummy for testing. Don't use this in production!
c.JupyterHub.authenticator_class = 'dummyauthenticator.DummyAuthenticator'
# use GitHub OAuthenticator for local users
#c.JupyterHub.authenticator_class = 'oauthenticator.LocalGitHubOAuthenticator'
#c.GitHubOAuthenticator.oauth_callback_url = os.environ['OAUTH_CALLBACK_URL']
# create system users that don't exist yet
c.LocalAuthenticator.create_system_users = True
# Allows multiple single-server per user
c.JupyterHub.allow_named_servers = True

# specify users and admin
#c.Authenticator.allowed_users = {'rgbkrk', 'minrk', 'jhamrick'}
#c.Authenticator.admin_users = {'jhamrick', 'rgbkrk'}

# launch with docker#####Spawner section##################################
c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'
# pick a docker image. This should have the same version of jupyterhub
# in it as our Hub.
c.DockerSpawner.image = 'jupyter/scipy-notebook:latest'
# To map a directory between inside and outside of the running image in docker spawner.
c.DockerSpawner.volumes = { 'path/to/local/directory':'/path/to/directory/inside/container'} 
# we need the hub to listen on all ips when it is in a container
c.JupyterHub.hub_ip = '0.0.0.0'
# the hostname/ip that should be used to connect to the hub
# this is usually the hub container's name
c.JupyterHub.hub_connect_ip = 'jupyterhub'
# tell the user containers to connect to our docker network
c.DockerSpawner.network_name = 'jupyterhub'
# delete containers when the stop
c.DockerSpawner.remove = True
###################### login page section
c.JupyterHub.template_paths = ['/usr/local/share/jupyter/hub/templates']

