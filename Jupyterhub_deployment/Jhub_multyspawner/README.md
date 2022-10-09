## Multy-spawner Jupyterhub

This is a Jupyterhub service with multy-image spawner capability. For configuring
the SSL see the ../Jhub_ssl/README.md.
You can give as many as image that you want in the spawner list in the
jupyterhub_config.py:

```bash
c.DockerSpawner.image_whitelist = {
	'Scipy':'jupyter/scipy-notebook:latest',
	'Data science':'jupyter/datascience-notebook:latest'
}
```
This will give you a list of images after logging in which you can choose
which image you want to run.

After doing all this preparations, you can run the Jupyterhub:

```bash
docker-compose up
```
and then navigate to https://localhost:8000 in your browser and login with any
username and 'jhubmulty' as password.
