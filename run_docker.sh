#!/bin/bash

IMAGE_NAME="ros:cam"

docker run --rm -it \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --user=$(id -un) \
  --network=host \
  --ipc=host \
  --pid=host \
  --privileged \
  $IMAGE_NAME \
  ros2 launch spinnaker_camera_driver driver_node.launch.py camera_type:=blackfly_s serial:="'20531756'"
