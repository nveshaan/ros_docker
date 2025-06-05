#!/bin/bash

IMAGE_NAME="ros:lid"

docker run --rm -it \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --user=$(id -un) \
  --network=host \
  --ipc=host \
  --pid=host \
  --env DISPLAY=$DISPLAY \
  --env XAUTHORITY=$XAUTHORITY \
  -v $XAUTHORITY:$XAUTHORITY \
  --privileged \
  $IMAGE_NAME \
  ros2 launch ouster_ros sensor.launch.xml sensor_hostname:=169.254.122.118 viz:=false 
