#!/bin/bash

container_name=$1
image_version=$2
port=$3
workspace_path=$4
resource_limit=$5

if [ -z $workspace_path ]
then
  echo "Some parameter value is empty. Usage: container-init.sh <container_name> <image_version> <port> <workspace_path> [<resource_limit>]"
exit 1
fi

echo "Create Jupyter notebook container for ADP centification."

if [[ $resource_limit == "unlimited" ]]
then
  resource=
else
  resource="--cpus=2 --memory=4g"
fi

(docker run --name $container_name -d -t -p ${port}:8888 -v $workspace_path:/workspace/Jupyter ${resource} hjben/adp-python:$image_version)
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
