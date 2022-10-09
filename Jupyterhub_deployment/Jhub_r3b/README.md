# Jhub_r3b
This Jupyterhub is designed to have a customized login page for the r3b jupyterhub server. To run this jupyterhub use the following command:
```bash
$ docker-compose up
```
and then navigate to https://localhost:8000 in your browser.

The login page is a HTML file in the ./template directory that is mapped to the /usr/local/share/jupyter/hub/templates directory inside the jupyterhub docker container via the docker-compose file. However, one needs to add ```
c.JupyterHub.template_paths = ['/usr/local/share/jupyter/hub/templates'] ``` in the jupyterhub config file to force the jupyterhub to use this login page instead of default one. 