#!/bin/bash

container_name=$1
image_version=$2
workspace_path=$3

if [ -z $image_version ]
then
  echo "Some parameter value is empty. Usage: container-init.sh <container_name> <image_version> <workspace_path>"
exit 1
fi

echo "Create Jupyter notebook container for ADP centification."
(docker run --name $container_name -d -t -p 8889:8889 -v $workspace_path:/workspace/Jupyter --cpus=2 --memory=4g hjben/adp-python:$image_version)
code=$?

if [ $code -gt 0 ]
then
  echo "Error raised while creating container. If container exists, remove the container using container-remove.sh file."
  exit 1
fi

echo "Done."
sleep 2

echo "Start Jupyter notebook service."
docker exec -it $container_name bash -c "jupyter-notebook --ip=0.0.0.0"
