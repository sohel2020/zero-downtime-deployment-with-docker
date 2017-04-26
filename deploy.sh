#!/bin/bash

# Edit these constants
APP_NAME="tonic-core"

NUM_OF_APP_CONTAINERS=2
DEPLOYMENT_TIME=15
DIR=${PWD##*/}
C_DIR="${DIR//-}"
P_GREP=$C_DIR$APP_NAME"_"
# End of edit

docker-compose build $APP_NAME # Use (docker-compose build $APP_NAME if you use a custom image)
docker-compose scale $APP_NAME=$(($NUM_OF_APP_CONTAINERS*2))
sleep $DEPLOYMENT_TIME
echo $P_GREP

FIRST_APP_CONTAINER_NUM=`docker inspect --format='{{.Name}}' $(docker ps -q) | grep $P_GREP | awk -F  "_" '{print $NF}' | sort -n | head -2`
CONTAINER_COUNT=`docker inspect --format='{{.Name}}' $(docker ps -q) | grep $P_GREP | awk -F  "_" '{print $NF}' | sort -n | head -2 | wc -l`

T_NUM=$(($CONTAINER_COUNT+$NUM_OF_APP_CONTAINERS))

for i in $FIRST_APP_CONTAINER_NUM
do
echo $i
  docker stop "$C_DIR"_"$APP_NAME"_"$i"
  docker rm "$C_DIR"_"$APP_NAME"_"$i"
done
