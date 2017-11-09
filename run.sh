#!/usr/bin/env bash

# Check args
if [ $# -lt 1 ]
then
  echo "usage: ./run.sh IMAGE_NAME [COMMAND]"
  exit 1
fi

# Get this script's path
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

IMAGE=$1
COMMAND=$SHELL
if [ $# -gt 1 ]
then
  shift
  COMMAND=$@
fi

#set -e

# Run the container with shared X11
docker run\
  --privileged\
  --net=host\
  -e SHELL\
  -e DISPLAY\
  -e DOCKER=1\
  -v "$HOME:$HOME:rw"\
  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw"\
  -it --rm $IMAGE $COMMAND

