# list of images here https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html
# exmamples of scripts here https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html

# docker run --rm -p 10000:8888 -e JUPYTER_ENABLE_LAB=yes -v "$PWD":/home/jovyan/work jupyter/datascience-notebook:9b06df75e445

sudo docker run --name dataquestio-jupyter -p 8888:8888 -v "$PWD":/home/jovyan jupyter/datascience-notebook

