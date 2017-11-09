#!/usr/bin/env bash

# Check args
if [ "$#" -ne 1 ]; then
  echo "usage: ./build.sh IMAGE_NAME"
  exit 1
fi

# Get this script's path
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

#WORKDIR=$SCRIPTPATH
WORKDIR=/simatch

# Build the docker image
docker build\
  --build-arg user=$USER\
  --build-arg uid=$UID\
  --build-arg home=$HOME\
  --build-arg workdir=$WORKDIR\
  --build-arg shell=$SHELL\
  -t $1 .

