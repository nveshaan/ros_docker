
> This container is a dev-ready environment made to get ROS 2 running on Linux as quickly as possible.

---

# Build
```bash
docker build --build-arg USER_UID=$(id -u) --build-arg USERNAME=$(id -un) -t ros:nv .
```

# Run
```bash
xhost +
docker run -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --user=$(id -un) --network=host --ipc=host --pid=host --privileged ros:nv
```
Either use `--rm` or `--name=ros` tags.

---

Be sure to run the following command before installing any packages:
```bash
sudo apt-get update
```
