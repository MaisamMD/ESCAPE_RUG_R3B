c = get_config()
import os
# use Generic OAuthenticator for local users
from oauthenticator.generic import GenericOAuthenticator

c.Application.log_level = 'DEBUG'

c.JupyterHub.authenticator_class = GenericOAuthenticator
c.GenericOAuthenticator.client_id =  os.environ['IAM_CLIENT_ID']
c.GenericOAuthenticator.client_secret = os.environ['IAM_CLIENT_SECRET']
c.GenericOAuthenticator.token_url = os.environ['OAUTH2_TOKEN_URL']
c.GenericOAuthenticator.oauth_callback_url = os.environ['OAUTH_CALLBACK_URL']
c.GenericOAuthenticator.userdata_url = 'https://iam-escape.cloud.cnaf.infn.it/userinfo'
c.OAuthenticator.tls_verify = False
c.GenericOAuthenticator.userdata_method = 'GET'
c.GenericOAuthenticator.userdata_params = {"state": "state"}
c.GenericOAuthenticator.username_key = "preferred_username"
c.GenericOAuthenticator.login_service = 'ESCAPE IAM'
c.GenericOAuthenticator.scope = ['openid', 'profile']
#c.Authenticator.auto_login = True

# create system users that don't exist yet
c.LocalAuthenticator.create_system_users = True
# Allows multiple single-server per user
#c.JupyterHub.allow_named_servers = True

# specify users and admin
#c.JupyterHub.port = 443
c.JupyterHub.ssl_cert = '/srv/jupyterhub/ssl/jhubssl.crt'
c.JupyterHub.ssl_key = '/srv/jupyterhub/ssl/jhubssl.key'
# launch with docker
c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'
# pick a docker image. This should have the same version of jupyterhub
# in it as our Hub.
c.DockerSpawner.image = 'jupyter/scipy-notebook:latest'
# we need the hub to listen on all ips when it is in a container
c.JupyterHub.hub_ip = '0.0.0.0'
#c.JupyterHub.bind_url = 'http://localhost'
# the hostname/ip that should be used to connect to the hub
# this is usually the hub container's name
#c.JupyterHub.hub_connect_ip = 'jupyterhub'
# tell the user containers to connect to our docker network
c.DockerSpawner.network_name = 'jupyterhub'
# delete containers when the stop
c.DockerSpawner.remove = True
