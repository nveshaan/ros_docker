
> This container is a dev-ready environment made to get ROS 2 running on Linux as quickly as possible.

---
# Prerequisites
Install the Spinnkaer SDK package from [here](https://www.teledynevisionsolutions.com/products/spinnaker-sdk/) into the same directory as the Dockerfile.

# Build
```bash
docker build --build-arg USER_UID=$(id -u) --build-arg USERNAME=$(id -un) -t ros:cam .
```

# Run
```bash
xhost +SI:localuser:$(id -un)
docker run -t --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --user=$(id -un) --network=host --ipc=host --pid=host --privileged ros:cam
```
Either use `--rm` or `--name=ros` tags.

---

Be sure to run the following command before installing any packages:
```bash
sudo apt-get update
```
