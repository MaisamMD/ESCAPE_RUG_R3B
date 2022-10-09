## Jupyterhub + ssl

Using this configuration one can enable ssl for Jupyterhub. For running
this service, put the ssl key and cert in the ssl/ folder. In the docker compose
file the ssl folder mounted and as a volume to a directory inside the container
('/srv/jupyterhub/ssl/'). If you don't have ssl cert and key, run the generate_ssl.sh
to generate them in the ssl/ directory:

```bash
$ ./generate_ssl.sh
```
After that you need to pass the ssl cert and key names in the jupyterhub_config.py
as a argument for:

```bash
c.JupyterHub.ssl_cert = '/srv/jupyterhub/ssl/myssl.crt'
c.JupyterHub.ssl_key = '/srv/jupyterhub/ssl/myssl.key'
```
To have a persistent data storage, the data/ directory mounted to the working
directory inside the container. To enable that, you need to pass the absolute path
of the ~/data/ directory in your host in the jupyterhub_config.py file:

```bash
c.DockerSpawner.volumes = {'/An/Absolute/Path/To/DATA Directory/In/Your host':'/home/jovyan/work'}
```

After doing all this preprations, you can run the Jupyterhub:

```bash
docker-compose up
```
and then navigate to https://localhost:8000 in your browser and login with any
username and password.
