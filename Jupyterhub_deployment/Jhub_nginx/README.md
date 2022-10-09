## Jupyterhub+nginx reverse proxy

This a Jupyterhub service with a nginx as a reverse proxy in front. The SSL enabled
for the nginx using self-signed certificate. The nginx and Jupyterhub run in
two different containers and being orchestrated by docker-compose. To run this
Jupyterhub service you need to put your ssl cert and key in ssl/ directory.
If not, generate them by running this script:

```bash
$ chmode +x generate_ssl.sh
$ ./generate_ssl.sh
```
If you have your own cert and key, you need to pass their path in the
nginx config file (nginx_config/nginx.conf). In this configuration, all the
requests will be secured and the traffic to the Jupyterhub service passes through
the nginx on port 80.

To have a persistent data storage, the data/ directory should be mounted to the working directory inside the container. To enable that, you need to pass the absolute path of the ~/data/ directory in your host in the jupyterhub_config.py file:

```bash
c.DockerSpawner.volumes = {'/An/Absolute/Path/To/DATA Directory/In/Your host':'/home/jovyan/work'}
```

After doing all this preprations, you can run the Jupyterhub:

```bash
docker-compose up
```
and then navigate to https://localhost:80 in your browser and login with any
username and password.
