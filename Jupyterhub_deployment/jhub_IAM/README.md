# Jhub_IAM
This Jupyterhub is configured to be able to use ESCAPE-IAM as the Auth/Z service.
To run this jupyterhub, you need use the follwing command in the current path:

```bash
$ docker-compose up
```
and then navigate to https://localhost:443 in your browser and click on the login button. The you will be redirected to the ESCAPE-IAM to enter your login credentials and then after succesfull authentication, you will be redirected back to the jupyterhub page and a notebook based on the image that you provided in the jupyterhub config file will be spawned.

## ESCAPE-IAM configuration

To use the ESCAPE-IAM as the authenticator in jupyterhub one needs to pass the following variables into the jupyterhub config file:

```bash
c.JupyterHub.authenticator_class = GenericOAuthenticator
c.GenericOAuthenticator.client_id =  os.environ['IAM_CLIENT_ID']
c.GenericOAuthenticator.client_secret = os.environ['IAM_CLIENT_SECRET']
c.GenericOAuthenticator.token_url = os.environ['OAUTH2_TOKEN_URL']
#c.GenericOAuthenticator.oauth_callback_url = os.environ['OAUTH_CALLBACK_URL']
c.GenericOAuthenticator.userdata_url = 'https://iam-escape.cloud.cnaf.infn.it/userinfo'
c.OAuthenticator.tls_verify = False
c.GenericOAuthenticator.userdata_method = 'GET'
c.GenericOAuthenticator.userdata_params = {"state": "state"}
c.GenericOAuthenticator.username_key = "preferred_username"
c.GenericOAuthenticator.login_service = 'ESCAPE IAM'
c.GenericOAuthenticator.scope = ['openid', 'profile']
```

The IAM_CLIENT_ID, IAM_CLIENT_SECRET, OAUTH2_TOKEN_URL, OAUTH_CALLBACK_URL are the parameters that you get when you register a application in ESCAPE_IAM portal.
For the ESCAPE-IAM client registration please see the [ESCAPE-IAM client registeration](https://indigo-iam.github.io/docs/v/current/user-guide/client-registration.html).